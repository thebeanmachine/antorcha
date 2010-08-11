class Permission < Resource
  belongs_to :role
  belongs_to :step
end
