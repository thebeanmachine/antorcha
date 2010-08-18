class Transaction < ActiveRecord::Base
  include CrossAssociatedModel
  
  validates_presence_of :title, :on => :update
  validates_presence_of :uri, :on => :update, :message => 'should have been assigned'
  validates_presence_of :definition

  default_scope :order => "transactions.created_at DESC"
  named_scope :with_organizations, lambda { |organization_ids| {
    :joins => {:messages => :deliveries}, 
    :conditions => {
      :messages => {
        :deliveries => {
          :organization_id => organization_ids
        }
      }
    }
  }}

  belongs_to_resource :definition
  has_many :messages

  after_create :format_title

  flagstamp :cancelled, :stopped

  attr_accessor :starting_step

  def validate_initiation
    errors.add_on_blank([:starting_step])
  end

  def update_uri uri
    update_attributes :uri => uri
  end

private
  def format_title
    update_attribute :title, "#{definition.title} \##{id}" if title.blank?
  end
  
  
end
