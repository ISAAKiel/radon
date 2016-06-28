class CountriesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @countries = Country.order("position ASC").all
    @countries_grid = initialize_grid(Country.with_permissions_to(:show),
    :name => 'countries',
    :include => [{:country_subdivisions=>{:sites => :samples}}],
    :enable_export_to_csv => false,
    :csv_file_name => 'countries'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:country].each_with_index do |id, index|
        Country.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @country = Country.find(params[:id])
  end
  
  def new
    @country = Country.new
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:notice] = "Successfully created country."
      redirect_to @country
    else
      render :action => 'new'
    end
  end
  
  def edit
    @country = Country.find(params[:id])
  end
  
  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = "Successfully updated country."
      redirect_to @country
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    flash[:notice] = "Successfully destroyed country."
    redirect_to countries_url
  end
end
