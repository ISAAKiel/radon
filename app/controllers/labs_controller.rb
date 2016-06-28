class LabsController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @labs = Lab.order('lab_code ASC')
    @labs_grid = initialize_grid(Lab.with_permissions_to(:show),
    :name => 'labs',
    :enable_export_to_csv => false,
    :csv_file_name => 'labs'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:labs].each_with_index do |id, index|
        Lab.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @lab = Lab.find(params[:id])
  end
  
  def new
    @lab = Lab.new
  end
  
  def create
    @lab = Lab.new(params[:lab])
    if @lab.save
      flash[:notice] = "Successfully created lab."
      redirect_to @lab
    else
      render :action => 'new'
    end
  end
  
  def edit
    @lab = Lab.find(params[:id])
  end
  
  def update
    @lab = Lab.find(params[:id])
    if @lab.update_attributes(params[:lab])
      flash[:notice] = "Successfully updated lab."
      redirect_to @lab
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @lab = Lab.find(params[:id])
    @lab.destroy
    flash[:notice] = "Successfully destroyed lab."
    redirect_to labs_url
  end
end
