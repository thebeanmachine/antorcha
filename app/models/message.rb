class Message < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :step

  belongs_to :step
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}
  
  def deliver
    puts "####### deliver"
    http = Net::HTTP.new("http://localhost", 3000)
    post = Net::HTTP::Post.new("http://localhost/messages")
    response = http.request(post, "bericht")
  end
end
