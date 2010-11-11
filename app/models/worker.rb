
require 'daemons'
require 'rbconfig'

class Worker
  WINDOZE = Config::CONFIG['host_os'] =~ /mswin|mingw/

  def self.all
    group = Daemons::ApplicationGroup.new('delayed_job')
    group.find_applications(File.join(Rails.root,'tmp','pids')).map do |app|
      Worker.new app
    end
  end

  def self.start
    if WINDOZE
      system "start \"Antorcha Engine\" \"#{File.join(Rails.root,'start_engine.bat')}\""
	    sleep 20
    else
      f = IO.popen "env RAILS_ENV=#{Rails.env} #{File.join(Rails.root,'script','delayed_job')} start"
	    f.readlines
      f.close
    end
  end

  def pid
    @application.pid.pid
  end
  
  def to_param
    pid.to_s
  end

  def running?
    @application.running?
  end
  
  def stop
  	if WINDOZE
  		system "taskkill /PID #{pid} /F"
  		sleep 3
  	else
  		@application.stop
  	end
  end

  def initialize app
    @application = app
  end
  
  def self.human_name(options = {})
    I18n.t("activerecord.models.worker", options)
  end
  
end
