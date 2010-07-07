# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


Antorcha.definition 'Huizenlijkgeweld' do |geweld|

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


if Rails.env.production?
  Antorcha.organization "Bureau Jeugdzorg test" do |lokaal|
    lokaal.destination_url "http://thorax:thorax@jeugdzorg.thebeanmachine.nl/messages"
  
    lokaal.fulfills "Bakkerij" => [ "Bakker" ]
    lokaal.fulfills "Huizenlijkgeweld" => [ "Bureau Jeugdzorg" ]
  end

  Antorcha.organization "Zorgaanbieder test" do |lokaal|
    lokaal.destination_url "http://thorax:thorax@zorgaanbieder.thebeanmachine.nl/messages"
  
    lokaal.fulfills "Bakkerij" => [ "Klant" ]
    lokaal.fulfills "Huizenlijkgeweld" => [ "Zorgaanbieder" ]
  end
else
  Antorcha.organization "Lokale machine" do |lokaal|
    lokaal.destination_url "http://localhost:3000/messages"

    lokaal.fulfills "Bakkerij" => [ "Bakker", "Klant"]
    lokaal.fulfills "Huizenlijkgeweld" => [ "Bureau Jeugdzorg", "Zorgaanbieder" ]
  end
end

