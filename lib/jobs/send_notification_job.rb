class Jobs::SendNotificationJob < Struct.new(:notifier_id)
  def perform
    notifier = Notifier.find notifier_id
    begin
      RestClient.post notifier.url, ''
    rescue RestClient::Exception
      # Nothing to worry about, 404 or 500 on the other side. Should show up in their logs.
      return
    end
  end
end