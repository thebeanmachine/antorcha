class Reception < ActiveRecord::Base

  validates_presence_of :certificate, :content
  serialize :content

  belongs_to :message
  
  
end
