# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create(:username => 'admin', :password => 'thorax', :password_confirmation => 'thorax', :email => "admin@foooo.br")
User.create(:username => 'henk', :password => 'thorax', :password_confirmation => 'thorax', :email => "henk@foooo.br")
User.create(:username => 'wim', :password => 'thorax', :password_confirmation => 'thorax', :email => "wim@foooo.br")
User.create(:username => 'piet', :password => 'thorax', :password_confirmation => 'thorax', :email => "piet@foooo.br")
User.create(:username => 'bep', :password => 'thorax', :password_confirmation => 'thorax', :email => "bep@foooo.br")

Antorcha.definition 'Huizelijkgeweld' do |geweld|

  geweld.role "Huisarts"
  geweld.role "Consulent"
  
  geweld.step "Melding maken" do |melding|
    melding.start
    
    melding.permits "Consulent"
    melding.recipients "Huisarts"
  end

  geweld.step "Dossier toesturen" do |toesturen|
    toesturen.follows "Melding maken"
    
    toesturen.permits "Huisarts"
    toesturen.recipients "Consulent"
  end

end

Antorcha.definition "Adviseren" do |bakkerij|

  bakkerij.role "Therapeut"
  bakkerij.role "Manager"
  
  bakkerij.step "Kneden" do |kneden|
    kneden.start
    kneden.permits "Therapeut"
    kneden.recipients "Therapeut"
  end

  bakkerij.step "Bakken" do |bakken|
    bakken.follows "Kneden"
    bakken.permits "Therapeut"
    bakken.recipients "Therapeut"
  end
  
  bakkerij.step "Verkoop" do |verkoop|
    verkoop.follows "Bakken"
    verkoop.permits "Therapeut"
    verkoop.recipients "Manager"
  end
end


if Rails.env.production?
  Antorcha.organization "Huisarts test" do |lokaal|
    lokaal.destination_url "http://thorax:thorax@jeugdzorg.thebeanmachine.nl/messages"
  

    lokaal.fulfills "Bakkerij" => [ "Bakker" ]
    lokaal.fulfills "Huizelijkgeweld" => [ "Bureau Jeugdzorg" ]

  end

  Antorcha.organization "Consulent test" do |lokaal|
    lokaal.destination_url "http://thorax:thorax@zorgaanbieder.thebeanmachine.nl/messages"
  

    lokaal.fulfills "Bakkerij" => [ "Klant" ]
    lokaal.fulfills "Huizelijkgeweld" => [ "Zorgaanbieder" ]

  end
else
  Antorcha.organization "Lokale machine" do |lokaal|
    lokaal.destination_url "http://localhost:3000/messages"


    lokaal.fulfills "Bakkerij" => [ "Bakker", "Klant"]
    lokaal.fulfills "Huizelijkgeweld" => [ "Bureau Jeugdzorg", "Zorgaanbieder" ]

  end
end

