class NotificationsController < ApplicationController

  def create
    @notifier = Notifier.find params[:notifier_id]
    @notifier.queue_notification
    #redirect_to notifier_url(@notifier), :notice => 'Notificatie is verstuurd.'
    redirect_to notifiers_url, :notice => 'Notificatie wordt momenteel verzonden.'
  end

end
