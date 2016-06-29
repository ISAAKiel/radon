class LiteraturesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy, :additional_collection => [:autocomplete, :un_api, :without_bibtex]

  def without_bibtex
    @literatures = Literature.order('short_citation ASC').where(:bibtex => nil)
    @literatures_grid = initialize_grid(Literature.with_permissions_to(:show),
    :name => 'literatures',
    :conditions => {:bibtex => nil},
    :enable_export_to_csv => false,
    :csv_file_name => 'literatures'
    )
    export_grid_if_requested

    render :action => 'index'
  end
  
  def index
    @literatures = Literature.order('short_citation ASC')
    @literatures_grid = initialize_grid(Literature.with_permissions_to(:show),
    :name => 'literatures',
    :enable_export_to_csv => false,
    :csv_file_name => 'literatures'
    )
    export_grid_if_requested
  end

  def autocomplete
    @literatures = Literature.order(:short_citation).where("lower(short_citation) like ?", "%#{params[:term].downcase}%")
    render json: @literatures.map {|u| Hash[id: u.id, literature_short_citation: u.short_citation, label: u.short_citation]}
  end
  
  def search
    @literatures = Literature.order(:name).where("name like ?", "%#{params[:term]}%")
    render json: @literatures.map(&:short_citation)
  end
  
  def show
    @literature = Literature.find(params[:id])
    if params[:pure]
      render @literature
    end
  end
  
  def new
    @literature = Literature.new
  end
  
  def create
    @literature = Literature.new(params[:literature])
    if @literature.save
      flash[:notice] = "Successfully created literature."
      redirect_to @literature
    else
      render :action => 'new'
    end
  end
  
  def edit
    @literature = Literature.find(params[:id])
  end
  
  def update
    @literature = Literature.find(params[:id])
    if @literature.update_attributes(params[:literature])
      flash[:notice] = "Successfully updated literature."
      redirect_to @literature
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @literature = Literature.find(params[:id])
    @literature.destroy
    flash[:notice] = "Successfully destroyed literature."
    redirect_to literatures_url
  end

  def un_api 
    if params[:id].nil?
      render :xml=>supported_formats(), 
                          :content_type => Mime::XML, :status => '200'
    else
      identifier = params[:id]
      if params[:format].nil?
        respond_to do |format|
          format.xml { render :xml=>supported_formats_for(identifier), 
                            :content_type => Mime::XML, :status => '200' }
        end
      else
        respond_to do |format|
         @literature = Literature.find(params[:id])
          unless @literature.to_bibtex.blank?
            render :text => @literature.to_bibtex
            return
          end
          return '404'
        end
      end
    end
  end

  private

  def supported_formats_for(identifier)
    @format ||= "<?xml version='1.0' encoding='UTF-8'?><formats>" +
                    "<formats id=\""+identifier+"\">" +
                    "<format name='bibtex' type='text/plain' />" +
                    "</formats>"
  end

  def supported_formats
    @format ||= "<?xml version='1.0' encoding='UTF-8'?><formats>" +
                    "<format name='bibtex' type='text/plain' />" +
                    "</formats>"
  end

end
