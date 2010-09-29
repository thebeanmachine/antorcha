namespace :requirement do

  desc "Check internetconnenction"
  task :online do  
    check system('ping -c 3 google.com'), 'ONLINE'
  end
  
  desc "Check ruby"
  task :ruby do
    check system('ruby --copyright'), 'RUBY'
  end
  
  desc "Check gems"
  task :gems => :ruby do  
    check system('rake gems:install'), 'GEMS'
  end

  desc "Check rails"
  task :rails => :gems do
    check system('rails -v'), 'RAILS'
  end
  
  desc "Check databases"
  task :database => :rails do
    check system('rake db:version'), 'DATABASE'
  end
  
  desc "Check accessibility"
  task :accessible => [:online, :environment] do
    raw_config = File.read(RAILS_ROOT + "/config/app_config.yml")
    APP_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
    url = URI.parse(APP_CONFIG[:olympus_resource])
    res = Net::HTTP.start(url.host, url.port) {|http| http.get("/org_available/#{Organization.ourself.id}")}
    check (res.body == "200"), 'ACCESSIBLE'
  end

  desc "Checks the internetconnenction, ruby, gems, rails, database and the accessibility"
  task :all => [:online, :ruby, :rails, :gems, :database, :accessible]
  
  def check(task, label)    
    puts "#{label} = #{task ? 'OK :)' : 'NIET OK :('}"
  end
  
end