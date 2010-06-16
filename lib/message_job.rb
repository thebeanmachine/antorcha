class MessageJob < Struct.new(:message_id)
  attr_reader :deleted, :created, :skipped, :updated, :unchanged
  
  def perform
    puts "###########being delivered"
    message = Message.find(message_id)
    message.deliver
    puts "###########deliver"
  end
end
