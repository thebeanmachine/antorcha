# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

def new_maintainer  
  puts "Een beheeraccount aanmaken"; p
  
  print "Voer uw emailadres in : "
  STDOUT.flush
  @email = STDIN.gets.chomp
  
  print "Voer uw gebruikersnaam in : "
  STDOUT.flush
  @username = STDIN.gets.chomp
  
  print "Voer uw nieuwe wachtoord in : "
  STDOUT.flush
  @password = STDIN.gets.chomp
  
  print "Bevestig uw nieuwe wachtwoord : "
  STDOUT.flush
  @confirmation = STDIN.gets.chomp  
end

def create_maintainer
  @maintainer = User.new(:email => @email, :username => @username);
  @maintainer.password = @password
  @maintainer.password_confirmation = @confirmation
  if @maintainer.save
    @maintainer.update_attribute(:user_type, "maintainer")
    @maintainer.update_attribute(:activated, true)
    print "Uw beheerderaccount is succesvol aangemaakt.\n"
  else    
    @maintainer.errors.full_messages.each do |error|
      p error
    end
    p; p "[ Beheeraccount niet aangemaakt. Nogmaals proberen a.u.b ]"; p 
    new_maintainer
  end
end

if User.maintainers.count == 0
  new_maintainer
  create_maintainer
else
  puts "Er is reeds een beheeraccount"
end