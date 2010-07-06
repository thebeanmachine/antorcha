# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

def seed model, conditions, attributes = {}
  if conditions.kind_of?(String)
    conditions = { :title => conditions }
  end
  
  conditions = conditions.inject({}) do |memo, (key, value) |
    memo[key] = case value
    when Proc:
      value.call
    else
      value
    end
    memo
  end
  instance = model.find(:first, :conditions => conditions)
  attributes = attributes.inject({}) do |memo, (key, value) |
    memo[key] = case value
    when Proc:
      value.call
    else
      value
    end
    memo
  end
  unless instance
    puts "===> Creating #{conditions.inspect} with #{attributes.inspect}"
    record = model.new(conditions.merge(attributes))
    unless record.save
      raise "#{record.errors.full_messages}"
    end
  else
    puts "---> Updating #{conditions.inspect} with #{attributes.inspect}"
    instance.update_attributes(attributes)
  end
  
  instance
end


Antorcha.definition 'Huisenlijkgeweld' do |geweld|

  geweld.role "Bureau Jeugdzorg"
  geweld.role "Zorgaanbieder"
  
  geweld.step "Melding maken" do |melding|
    melding.start
    
    melding.permits "Zorgaanbieder"
    melding.recipients "Bureau Jeugdzorg"
  end

  geweld.step "Dossier toesturen" do |toesturen|
    toesturen.follows "Melding maken"
    
    toesturen.permits "Bureau Jeugdzorg"
    toesturen.recipients "Zorgaanbieder"
  end

end

Antorcha.definition "Bakkerij" do |bakkerij|

  bakkerij.role "Bakker"
  bakkerij.role "Klant"
  
  bakkerij.step "Kneden" do |kneden|
    kneden.start
    kneden.permits "Bakker"
    kneden.recipients "Bakker"
  end

  bakkerij.step "Bakken" do |bakken|
    bakken.follows "Kneden"
    bakken.permits "Bakker"
    bakken.recipients "Bakker"
  end
  
  bakkerij.step "Verkoop" do |verkoop|
    verkoop.follows "Bakken"
    verkoop.permits "Bakker"
    verkoop.recipients "Klant"
  end

end


