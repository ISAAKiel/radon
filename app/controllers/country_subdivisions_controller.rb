class CountrySubdivisionsController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 

  def get_country_subdivisions_by_country
    @country_subdivisions=CountrySubdivision.where(:country_id => params[:country_id]) unless params[:country_id].blank?
  end
  
  def index
    @country_subdivisions = CountrySubdivision.all
    @country_subdivisions_grid = initialize_grid(CountrySubdivision.with_permissions_to(:show),
    :name => 'country_subdivisions',
    :include => [{:sites => :samples}, :country],
    :enable_export_to_csv => false,
    :csv_file_name => 'countries'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:country_subdivision].each_with_index do |id, index|
        CountrySubdivision.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @country_subdivision = CountrySubdivision.find(params[:id])
  end
  
  def new
    @country_subdivision = CountrySubdivision.new
  end
  
  def create
    @country_subdivision = CountrySubdivision.new(params[:country_subdivision])
    if @country_subdivision.save
      flash[:notice] = "Successfully created country subdivision."
      redirect_to @country_subdivision
    else
      render :action => 'new'
    end
  end
  
  def edit
    @country_subdivision = CountrySubdivision.find(params[:id])
  end
  
  def update
    @country_subdivision = CountrySubdivision.find(params[:id])
    if @country_subdivision.update_attributes(params[:country_subdivision])
      flash[:notice] = "Successfully updated country subdivision."
      redirect_to @country_subdivision
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @country_subdivision = CountrySubdivision.find(params[:id])
    @country_subdivision.destroy
    flash[:notice] = "Successfully destroyed country subdivision."
    redirect_to country_subdivisions_url
  end
end
