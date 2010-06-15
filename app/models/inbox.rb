class Inbox < ActiveRecord::Base
  has_many :items
end
