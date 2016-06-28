class RightsController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 

  def index
    @rights = Right.order("position ASC").all
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:rights].each_with_index do |id, index|
        Right.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @right = Right.find(params[:id])
  end
  
  def new
    @right = Right.new
  end
  
  def create
    @right = Right.new(params[:right])
    if @right.save
      flash[:notice] = "Successfully created right."
      redirect_to @right
    else
      render :action => 'new'
    end
  end
  
  def edit
    @right = Right.find(params[:id])
  end
  
  def update
    @right = Right.find(params[:id])
    if @right.update_attributes(params[:right])
      flash[:notice] = "Successfully updated right."
      redirect_to @right
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @right = Right.find(params[:id])
    @right.destroy
    flash[:notice] = "Successfully destroyed right."
    redirect_to rights_url
  end
end
