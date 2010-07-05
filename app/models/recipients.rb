class Recipients < ActiveRecord::Base
  belongs_to :step
  belongs_to :role
end
