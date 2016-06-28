class DatingMethodsController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @dating_methods = DatingMethod.all
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:dating_methods].each_with_index do |id, index|
        DatingMethod.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @dating_method = DatingMethod.find(params[:id])
  end
  
  def new
    @dating_method = DatingMethod.new
  end
  
  def create
    @dating_method = DatingMethod.new(params[:dating_method])
    if @dating_method.save
      flash[:notice] = "Successfully created dating method."
      redirect_to @dating_method
    else
      render :action => 'new'
    end
  end
  
  def edit
    @dating_method = DatingMethod.find(params[:id])
  end
  
  def update
    @dating_method = DatingMethod.find(params[:id])
    if @dating_method.update_attributes(params[:dating_method])
      flash[:notice] = "Successfully updated dating method."
      redirect_to @dating_method
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @dating_method = DatingMethod.find(params[:id])
    @dating_method.destroy
    flash[:notice] = "Successfully destroyed dating method."
    redirect_to dating_methods_url
  end
end
