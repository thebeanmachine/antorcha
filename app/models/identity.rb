class Identity < ActiveRecord::Base
  include CrossAssociatedModel

  belongs_to_record :organization

  validates_presence_of :organization, :private_key

end

