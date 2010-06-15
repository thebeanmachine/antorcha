class ItemsController < ApplicationController
  before_filter :find_inbox
  
  def index
    @items = @inbox.items
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = @inbox.items.build(params[:item])    
    if @item.save
      redirect_to inbox_item_path(@inbox, @item)
    else
      render :action => "new"
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to inbox_item_path(@inbox, @item)
    else
      render :action => "edit"
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to inbox_items_path(@inbox)
  end
  
private
  
  def find_inbox
    @inbox = Inbox.find(params[:inbox_id])
  end
end
