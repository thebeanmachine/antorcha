class Notifier < ActiveRecord::Base
  validates_presence_of :url
  validates_format_of :url, :with => URI.regexp(['http']), :allow_blank => true
  
  default_scope :order => 'notifiers.url ASC'

  def title
    url
  end

  def self.queue_all_notifications
    all.each &:queue_notification
  end

  def queue_notification
    Delayed::Job.enqueue Jobs::SendNotificationJob.new(id)
  end
end
