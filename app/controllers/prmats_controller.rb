class PrmatsController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 
  
  def index
    @prmats = Prmat.all
    @prmats_grid = initialize_grid(Prmat.with_permissions_to(:show),
    :name => 'prmats',
    :enable_export_to_csv => false,
    :csv_file_name => 'prmats'
    )
    export_grid_if_requested
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:prmats].each_with_index do |id, index|
        Prmat.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  
  def show
    @prmat = Prmat.find(params[:id])
  end
  
  def new
    @prmat = Prmat.new
  end
  
  def create
    @prmat = Prmat.new(params[:prmat])
    if @prmat.save
      flash[:notice] = "Successfully created prmat."
      redirect_to @prmat
    else
      render :action => 'new'
    end
  end
  
  def edit
    @prmat = Prmat.find(params[:id])
  end
  
  def update
    @prmat = Prmat.find(params[:id])
    if @prmat.update_attributes(params[:prmat])
      flash[:notice] = "Successfully updated prmat."
      redirect_to @prmat
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @prmat = Prmat.find(params[:id])
    @prmat.destroy
    flash[:notice] = "Successfully destroyed prmat."
    redirect_to prmats_url
  end
end
