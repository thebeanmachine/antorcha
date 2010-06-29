
require 'daemons'

class Worker
  def self.all
    group = Daemons::ApplicationGroup.new('delayed_job')
    group.find_applications(File.join(Rails.root,'tmp','pids')).map do |app|
      Worker.new app
    end
  end

  def self.start
    begin
      Delayed::Command.new(['start']).daemonize
    rescue SystemExit
      puts "owke"
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
    @application.stop
  end

  def initialize app
    @application = app
  end
  
  def self.human_name(options = {})
    I18n.t("activerecord.models.worker", options)
  end
  
end
