class PhasesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy 

  def get_phases_by_culture
    @phases=Phase.find(:all, :conditions => {:culture_id => params[:culture_id]}) unless params[:culture_id].blank?
  end

  def sort
    if (defined? current_user.roles) && (current_user.roles.map(&:name).detect {|role| role == "admin"}) 
      params[:phases].each_with_index do |id, index|
        Phase.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end

  
  def index
    @phases = Phase.order("position ASC").all
  end
  
  def show
    @phase = Phase.find(params[:id])
  end
  
  def new
    @phase = Phase.new
  end
  
  def create
    @phase = Phase.new(params[:phase])
    if @phase.save
      flash[:notice] = "Successfully created phase."
      redirect_to @phase
    else
      render :action => 'new'
    end
  end
  
  def edit
    @phase = Phase.find(params[:id])
  end
  
  def update
    @phase = Phase.find(params[:id])
    if @phase.update_attributes(params[:phase])
      flash[:notice] = "Successfully updated phase."
      redirect_to @phase
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @phase = Phase.find(params[:id])
    @phase.destroy
    flash[:notice] = "Successfully destroyed phase."
    redirect_to phases_url
  end
end
