class CulturesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @cultures = Culture.all
    @cultures_grid = initialize_grid(Culture.with_permissions_to(:show),
    :include => [:phases],
    :name => 'cultures',
    :enable_export_to_csv => false,
    :csv_file_name => 'cultures'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:cultures].each_with_index do |id, index|
        Culture.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end

  def show
    @culture = Culture.find(params[:id])
  end
  
  def new
    @culture = Culture.new
  end
  
  def create
    @culture = Culture.new(params[:culture])
    if @culture.save
      flash[:notice] = "Successfully created culture."
      redirect_to @culture
    else
      render :action => 'new'
    end
  end
  
  def edit
    @culture = Culture.find(params[:id])
  end
  
  def update
    @culture = Culture.find(params[:id])
    if @culture.update_attributes(params[:culture])
      flash[:notice] = "Successfully updated culture."
      redirect_to @culture
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @culture = Culture.find(params[:id])
    @culture.destroy
    flash[:notice] = "Successfully destroyed culture."
    redirect_to cultures_url
  end
end
