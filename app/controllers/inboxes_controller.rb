class InboxesController < ApplicationController

  def index
    @inboxes = Inbox.all
  end

  def show
    @inbox = Inbox.find(params[:id])
    @items = @inbox.items
  end

  def new
    @inbox = Inbox.new
  end

  def edit
    @inbox = Inbox.find(params[:id])
  end

  def create
    @inbox = Inbox.new(params[:inbox])

      if @inbox.save
        redirect_to(@inbox, :notice => 'Inbox was successfully created.')
      else
        render :action => "new"
      end
  end

  def update
    @inbox = Inbox.find(params[:id])

      if @inbox.update_attributes(params[:inbox])
        redirect_to(@inbox, :notice => 'Inbox was successfully updated.')
      else
        render :action => "edit"
      end
  end

  def destroy
    @inbox = Inbox.find(params[:id])
    @inbox.destroy
  end
end
