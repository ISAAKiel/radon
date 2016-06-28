class SitesController < ApplicationController

  filter_access_to :index, :show, :edit, :new, :create, :update, :destroy, :without_geolocalisation, :collection => [:without_geolocalisation, :with_geolocalisation]
    
  def get_sites_by_country_subdivision
    @sites=Site.where(:country_subdivision_id => params[:country_subdivision_id]) unless params[:country_subdivision_id].blank?
  end
  
  def without_geolocalisation
    @sites = Site.with_permissions_to(:show).where(:lat => nil, :lng => nil )
#    @sites = Site.find(:all, :conditions => {:lat => nil, :lng => nil })
#    render :template => 'sites/index', :locals => {:sites => @sites}
    @sites_grid = initialize_grid(@sites,
    :name => 'sites',
    :enable_export_to_csv => false,
    :include => [{:country_subdivision => :country}],
    :csv_file_name => 'sites'
    )
    export_grid_if_requested

    render :action => 'index'
  end

  def with_geolocalisation
    @sites = Site.with_permissions_to(:show).where('lat is not null and lng is not null').order(:name)
#    @sites = Site.find(:all, :conditions => {:lat => nil, :lng => nil })
#    render :template => 'sites/index', :locals => {:sites => @sites}

    @sites_grid = initialize_grid(@sites,
    :name => 'sites',
    :enable_export_to_csv => false,
    :include => [{:country_subdivision => :country}],
    :csv_file_name => 'sites'
    )
    export_grid_if_requested
    
    render :action => 'index'
  end

  def index
    if params[:search].blank?
      @sites = Site.all
    else
#      @sites = Site.paginate :page => params[:page], :per_page => 20
      @sites = Site.where([ 'lower(name) LIKE ?', "#{params[:search].downcase}%" ])
    end

    @sites_grid = initialize_grid(Site.with_permissions_to(:show),
    :name => 'sites',
    :enable_export_to_csv => false,
    :include => [{:country_subdivision => :country}],
    :csv_file_name => 'sites'
    )
    export_grid_if_requested
    
    respond_to do |format|
      format.html # index.rhtml
      format.js { render :layout => false }
      format.xml  { render :xml => @sites.to_xml }
    end
  end
  
  def show
    @site = Site.find(params[:id])
  end
  
  def new
    @site = Site.new
  end
  
  def create
    if params[:site][:lat] && params[:site][:lng]
#      enrich_site
    end
    @site = Site.new(params[:site])
    if params[:commit]=="Search"
#      @location_count = propose_locations
      @location_proposals = Site.propose_locations(params[:search])["geonames"]
      site_locations= Site.where( "lower(sites.name) LIKE ?", "%#{params[:search].downcase}%").includes(country_subdivision: :country)
      @locations_from_sites = site_locations
      render :action => 'new'       
    elsif @site.save
      flash[:notice] = "Successfully created site."
      redirect_to @site
    else
      render :action => 'new'
    end
  end
  
  def edit
    @site = Site.find(params[:id])
    @location_proposals=[]
    @locations_from_sites = [@site]
  end
  
  def update
    @site = Site.find(params[:id])
    if params[:site][:lat] && params[:site][:lng]
#      enrich_site
    end
    if params[:commit]=="Search"
#      @location_count = propose_locations
      @location_proposals = Site.propose_locations(params[:search])["geonames"]
      site_locations= Site.where( "lower(sites.name) LIKE ?", "%#{params[:search].downcase}%").includes(country_subdivision: :country)
      @locations_from_sites = site_locations
      render :action => 'edit'       
    elsif
      @site.update_attributes(params[:site])
      flash[:notice] = "Successfully updated site."
      redirect_to @site
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    flash[:notice] = "Successfully destroyed site."
    redirect_to sites_url
  end

  protected

  def enrich_site
 
    url = "http://ws.geonames.org" + "/countrySubdivisionJSON?a=a"
    url = url + "&lat=#{params[:site][:lat]}&lng=#{params[:site][:lng]}"
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
    
    answer_finished=false
    answer_counter=0
    until answer_finished
    
    res = Net::HTTP.start( uri.host, uri.port ) { |http|
      http.request( req )
    }
    answer_counter=answer_counter+1
      if ((res==Net::HTTPSuccess)||(answer_counter>10 ))
        answer_finished=true
      end
    end
    
    doc = ActiveSupport::JSON.decode(res.body)
    site_adm1_name=doc['adminName1'] || "n/a"
    site_country_name=doc['countryName'] || "n/a"

    if params[:site_country_subdivision_id] && params[:site_country_subdivision_id]!='undefined'
      params[:site][:country_subdivision_id]=params[:site_country_subdivision_id]
    else
        site_country=Country.find_or_initialize_by_name(site_country_name)
        site_country.abreviation=doc['countryCode']
        site_country.save #neue Abkürzungen übernehmen!
        country_subdivison_conditions = { 
                 :country_id => site_country.id,
                 :name => site_adm1_name }
        country_subdivison = CountrySubdivision.first(:conditions => country_subdivison_conditions) || CountrySubdivision.new(country_subdivison_conditions)
        country_subdivison.save
        params[:site][:country_subdivision_id]=country_subdivison.id
    end
  end
end
