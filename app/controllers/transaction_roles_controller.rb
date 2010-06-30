class TransactionRolesController < ApplicationController
  # GET /transaction_roles
  # GET /transaction_roles.xml
  def index
    @transaction_roles = TransactionRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transaction_roles }
    end
  end

  # GET /transaction_roles/1
  # GET /transaction_roles/1.xml
  def show
    @transaction_role = TransactionRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction_role }
    end
  end

  # GET /transaction_roles/new
  # GET /transaction_roles/new.xml
  def new
    @transaction_role = TransactionRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction_role }
    end
  end

  # GET /transaction_roles/1/edit
  def edit
    @transaction_role = TransactionRole.find(params[:id])
  end

  # POST /transaction_roles
  # POST /transaction_roles.xml
  def create
    @transaction_role = TransactionRole.new(params[:transaction_role])

    respond_to do |format|
      if @transaction_role.save
        format.html { redirect_to(@transaction_role, :notice => 'TransactionRole was successfully created.') }
        format.xml  { render :xml => @transaction_role, :status => :created, :location => @transaction_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transaction_roles/1
  # PUT /transaction_roles/1.xml
  def update
    @transaction_role = TransactionRole.find(params[:id])

    respond_to do |format|
      if @transaction_role.update_attributes(params[:transaction_role])
        format.html { redirect_to(@transaction_role, :notice => 'TransactionRole was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_roles/1
  # DELETE /transaction_roles/1.xml
  def destroy
    @transaction_role = TransactionRole.find(params[:id])
    @transaction_role.destroy

    respond_to do |format|
      format.html { redirect_to(transaction_roles_url) }
      format.xml  { head :ok }
    end
  end
end
