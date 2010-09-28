task :online do
  if system 'ping -c 3 google.com'
    puts "ONLINE = OK :)"
  else
    puts "ONLINE = NOT OK :("
  end
end

task :ruby do
  if system 'ruby --copyright'
    puts "RUBY = OK :)"
  else
    puts "RUBY = NOT OK :("
  end
end

task :gems => :ruby do
  if system 'rake gems:install'
    puts "GEMS = OK :)"
  else
    puts "GEMS = NOT OK :("
  end
end

task :rails => :gems do
  if system 'rails -v'
    puts "RAILS = OK :)"
  else
    puts "RAILS = NOT OK :("
  end
end

task :database => :rails do
  if system 'rake db:version'
    puts "DATABASE = OK :)"
  else
    puts "DATABASE = NOT OK :("
  end
end

task :available => [:environment] do
  raw_config = File.read(RAILS_ROOT + "/config/app_config.yml")
  APP_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
  # olympus = APP_CONFIG[:olympus_resource]
  olympus = "http://localhost:3000"
  p Net::HTTP.get_print olympus, '/org_available'
  
  # system "curl olympus.heroku.com/org_available/#{Organization.ourself.id}"
  # puts Organization.ourself.url  
end

