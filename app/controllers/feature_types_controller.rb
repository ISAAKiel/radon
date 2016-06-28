class FeatureTypesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @feature_types = FeatureType.all
    @feature_types_grid = initialize_grid(FeatureType.with_permissions_to(:show),
    :name => 'feature_types',
    :enable_export_to_csv => false,
    :csv_file_name => 'feature_types'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:feature_types].each_with_index do |id, index|
        FeatureType.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @feature_type = FeatureType.find(params[:id])
  end
  
  def new
    @feature_type = FeatureType.new
  end
  
  def create
    @feature_type = FeatureType.new(params[:feature_type])
    if @feature_type.save
      flash[:notice] = "Successfully created feature type."
      redirect_to @feature_type
    else
      render :action => 'new'
    end
  end
  
  def edit
    @feature_type = FeatureType.find(params[:id])
  end
  
  def update
    @feature_type = FeatureType.find(params[:id])
    if @feature_type.update_attributes(params[:feature_type])
      flash[:notice] = "Successfully updated feature type."
      redirect_to @feature_type
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @feature_type = FeatureType.find(params[:id])
    @feature_type.destroy
    flash[:notice] = "Successfully destroyed feature type."
    redirect_to feature_types_url
  end
end
