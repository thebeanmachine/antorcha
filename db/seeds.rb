# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

seeds = {
  Step => {
    {:title => 'Hello world'} => {:start => true }
  }
}

seeds.each do |model, instances|
  instances.each do |conditions, attributes|
    instance = model.find(:first, :conditions => conditions)
    unless instance
      puts "===> Creating #{conditions.inspect}"
      model.create(conditions.merge(attributes))
    else
      puts "---> Updating #{conditions.inspect} with #{attributes.inspect}"
      instance.update_attributes(attributes)
    end
  end
end

