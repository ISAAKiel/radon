class SamplesController < ApplicationController
  include ApplicationHelper

  filter_access_to :new, :create, :edit, :update, :destroy, :calibrate_multi, :export_chart, :calibrate_sum
  filter_access_to :show, :show, :calibrate, :attribute_check => true

#  filter_resource_access

  def index
    safe_scopes = %w(countries.id cultures.id phases.id feature_types.id labs.id literatures.id prmats.id sites.id country_subdivisions.id)
    scope=[]
    
    scope_hash=params[:scope]
    if scope_hash
      scope_hash.delete_if {|k,v| ! safe_scopes.include?(k) }
      scope=[scope_hash.keys.map{|k| "#{k} = ?" }.join(" AND "), scope_hash.values].flatten
    end
     
    if params[:bbox]

      bbox=params[:bbox].split(',')
      
      old_scope_head = scope[0] + ' AND ' if scope_hash
      
      if scope[0] then scope[0]= old_scope_head + 'sites.lat >= ? AND sites.lat <= ? AND sites.lng >= ? AND sites.lng <= ?' end
      scope.push('sites.lat >= ? AND sites.lat <= ? AND sites.lng >= ? AND sites.lng <= ?') if !scope[0]
      
      scope.push(bbox[1].to_f,bbox[3].to_f,bbox[0].to_f,bbox[2].to_f)
    end

    #@samples = Sample.with_permissions_to(:show).paginate :page => params[:page], :per_page => 20, :order => params[:sort]

    @samples_grid = initialize_grid(Sample.with_permissions_to(:show),
    :include => [:lab, :prmat, :feature_type, {:site=>{:country_subdivision => :country}}, {:phase => :culture}, :literatures],
    :name => 'samples',
    :conditions=>scope,
    :enable_export_to_csv => true,
    :csv_field_separator => ';'#,
#    :csv_file_name => 'samples'
    )
    export_grid_if_requested
    
@map='<script defer="defer" type="text/javascript">'

@map << 'var map;'

@map << 'map = new OpenLayers.Map("map", {theme : false,projection : "new OpenLayers.Projection(\"EPSG:900913\")",displayProjection : "new OpenLayers.Projection(\"EPSG:4326\")"});'

      @map << '
              var proj = new OpenLayers.Projection("EPSG:4326");'


      @map << '
            OpenLayers.Feature.Vector.style["default"]["strokeWidth"] = "2";

            var cursors = ["sw-resize", "s-resize", "se-resize",
                "e-resize", "ne-resize", "n-resize", "nw-resize", "w-resize"];
            var context = {
                getCursor: function(feature){
                    var i = OpenLayers.Util.indexOf(controls["transform"].handles, feature);
                    var cursor = "inherit";
                    if(i !== -1) {
                        i = (i + 8 + Math.round(controls["transform"].rotation / 90) * 2) % 8;
                        cursor = cursors[i];
                    }
                    return cursor;
                }
            };
            
            // a nice style for the transformation box
            var style = new OpenLayers.Style({
                cursor: "${getCursor}",
                pointRadius: 5,
                fillColor: "white",
                fillOpacity: 1,
                strokeColor: "black"
            }, {context: context});

            var renderer = OpenLayers.Util.getParameters(window.location.href).renderer;
            renderer = (renderer) ? [renderer] : OpenLayers.Layer.Vector.prototype.renderers;

            var vectors = new OpenLayers.Layer.Vector("Simple Geometry", {
                styleMap: new OpenLayers.StyleMap({
                    "transform": style
                })
            });
            var osm = new OpenLayers.Layer.OSM();

            map.addLayers([osm, vectors]);
                var       controls = {
                regular: new OpenLayers.Control.DrawFeature(vectors,
                            OpenLayers.Handler.RegularPolygon,
                            {handlerOptions: {sides: 4, irregular:true}})
            };
            
            for(var key in controls) {
                map.addControl(controls[key]);
            };
            
            controls.regular.handler.irregular = true;
            
            controls["transform"] = new OpenLayers.Control.TransformFeature(vectors, {
                renderIntent: "transform",
                irregular: true
            });
            
            function addedBox() {
            controls["regular"].deactivate();
            controls["transform"].setFeature(vectors.features[0]);
            controls["transform"].activate();
            }
            
            vectors.events.on({"featureadded": addedBox});
            
            map.addControl(controls["transform"]);

            var button1 = new OpenLayers.Control.Button ({trigger: function() {vectors.removeFeatures(vectors.features);controls["regular"].activate();controls["transform"].deactivate();}, title: "Draw Selection Frame", text: "Draw Selection Frame"});

            var button2 = new OpenLayers.Control.Button ({trigger: function() {var customer_url = "' + url_for(params.merge(:bbox => "nil")) + '";
  customer_url = customer_url.replace("nil",encodeURIComponent(vectors.features[0].geometry.bounds.transform(map.getProjectionObject(),proj)));
  window.location = customer_url;
  }, title: "Enable filter", text: "Enable filter"});
            panel = new OpenLayers.Control.Panel({defaultControl: button1, createControlMarkup: function(control) {
            var button = $("<button class=\'btn btn-info btn-xs\'  style=\'margin-top: 5px;margin-left: 5px;\'>")[0],
                iconSpan = document.createElement("span"),
                textSpan = document.createElement("span");
            iconSpan.innerHTML = "&nbsp;";
            button.appendChild(iconSpan);
            if (control.text) {
                textSpan.innerHTML = control.text;
            }
            button.appendChild(textSpan);
            return button;
        }, class: "btn-group"
});
            panel.addControls([button1,button2]);
            map.addControl (panel);
            '
            @map << 'map.setCenter(new OpenLayers.LonLat(7, 48.9).transform(proj,map.getProjectionObject()), 5);
                     setTimeout(function () {map.setBaseLayer(ghyb);}, 1000);'
            
          if params[:bbox]

            @map << "
            var p1 = new OpenLayers.Geometry.Point(#{bbox[0]},#{bbox[1]}).transform(proj,map.getProjectionObject());
            var p2 = new OpenLayers.Geometry.Point(#{bbox[0]},#{bbox[3]}).transform(proj,map.getProjectionObject());
            var p3 = new OpenLayers.Geometry.Point(#{bbox[2]},#{bbox[3]}).transform(proj,map.getProjectionObject());
            var p4 = new OpenLayers.Geometry.Point(#{bbox[2]},#{bbox[1]}).transform(proj,map.getProjectionObject());
         
            var points = [];
            points.push(p1);
            points.push(p2);
            points.push(p3);
            points.push(p4);
         
            // create a polygon feature from a list of points
            var linearRing = new OpenLayers.Geometry.LinearRing(points);

            
            var polygonFeature = new OpenLayers.Feature.Vector(linearRing, null);

            vectors.addFeatures([polygonFeature]);
            
            map.zoomToExtent(vectors.getDataExtent());
            "
          end
@map << '</script>'
#    end          
  end
  
  def show
    @sample = Sample.find(params[:id])
  end
  
  def new
    @sample = Sample.new
    @sample.build_site
  end
  
  def create
    @sample = Sample.new(params[:sample])
    unless params[:hidden_site_id].blank?
      @sample.site = Site.find(params[:hidden_site_id])
      params[:sample] = params[:sample].except(:site_attributes)
#      params[:sample][:site_id] = params[:hidden_site_id]
    end
#    set_site
    if params[:commit]=="Search"
      @location_proposals = Site.propose_locations(params[:search]).fetch(:geonames,[])
      site_locations= Site.where( "lower(sites.name) LIKE ?", "%#{params[:search].downcase}%").includes(country_subdivision: :country)
      @locations_from_sites = site_locations
      render :action => 'new'       
    elsif @sample.save
      flash[:notice] = "Successfully created sample."
      redirect_to @sample
      session[:users_last_site]=@sample.site
    else
      @sample = Sample.new(params[:sample])
      render :action => 'new'
    end
  end
  
  def edit
    @sample = Sample.find(params[:id])
    @location_proposals=[]
    @locations_from_sites = [@sample.site]
  end
  
  def update
    @sample = Sample.find(params[:id])
    unless params[:hidden_site_id].blank?
      @sample.site = Site.find(params[:hidden_site_id])
      params[:sample] = params[:sample].except(:site_attributes)
#      params[:sample][:site_id] = params[:hidden_site_id]
    end
#    set_site
    if params[:commit]=="Search"
      @location_proposals = Site.propose_locations(params[:search])["geonames"]
      site_locations= Site.where( "lower(sites.name) LIKE ?", "%#{params[:search].downcase}%").includes(country_subdivision: :country)
      @locations_from_sites = site_locations
      render :action => 'edit'       
    elsif @sample.update_attributes(params[:sample])
      flash[:notice] = "Successfully updated sample."
      redirect_to @sample
      session[:users_last_site]=@sample.site
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sample = Sample.find(params[:id])
    @sample.destroy
    flash[:notice] = "Successfully destroyed sample."
    redirect_to samples_url
  end
  
  def calibrate
    @sample = Sample.with_permissions_to(:show).find(params[:id])
    out="Options(){RawData=TRUE};Plot(){R_Date(\"#{@sample.name}\",#{@sample.bp},#{@sample.std});};"
    File.open('tmp/radon_calib.oxcal', 'w') {|f| f.write(out) }
    `vendor/oxcal/OxCalLinux tmp/radon_calib.oxcal`
    @log = File.read('tmp/radon_calib.log')
    @graph = File.read('tmp/radon_calib.js')
    @log=@log.split("\n")[6..-1].join("\n")
    result_lines=@log.scan(/\n/).length
    @result_lines=result_lines
    likelihood_start = @graph[/(likelihood.start=)(.*)(;)/,2].to_f
#    @likelihood_start=Time.local(likelihood_start,1,1)
    @likelihood_start=Time.mktime(likelihood_start)
    @likelihood_res = @graph[/(likelihood.resolution=)(.*)(;)/,2].to_f
        
    likelihood_prob_string=@graph[/(likelihood.prob=\[)(.*)(\];)/,2]
    likelihood_prob_norm=@graph[/(likelihood.probNorm=)(.*)(;)/,2]
    likelihood_probs=likelihood_prob_string.split(', ').map{|prob| prob.to_f*likelihood_prob_norm.to_f}
    calib_cal_string=@graph[/(calib\[0\].rawcal=\[)(.*)(\];)/,2]
    @calib_cal=calib_cal_string.split(',').map{|prob| prob.to_f}
    calib_bp_string=@graph[/(calib\[0\].rawbp=\[)(.*)(\];)/,2]
    @calib_bp=calib_bp_string.split(',').map{|prob| prob.to_f}
    calib_sigma_string=@graph[/(calib\[0\].rawsigma=\[)(.*)(\];)/,2]
    @calib_sigma=calib_sigma_string.split(',').map{|prob| prob.to_f}

    timespan=likelihood_probs.length * @likelihood_res
    @likelihood_end = Time.mktime(likelihood_start+timespan)
    
    @calib_data=Array.new
    @calib_data[0]=@calib_cal
    @calib_data[1]=@calib_bp
    @calib_data[2]=@calib_bp.zip(@calib_sigma).map{ |pair| pair[0] + pair[1] }
    @calib_data[3]=@calib_bp.zip(@calib_sigma).map{ |pair| pair[0] - pair[1] }
    @calib_data=@calib_data.transpose
    
    @calib_data_out=String.new
    calib_data_out_tmp=Array.new
    calib_upper_out_tmp=Array.new
    calib_lower_out_tmp=Array.new
    
    @calib_data.each do |a|
     if ((a[0]>=likelihood_start) && ((likelihood_start + timespan) >=a[0]))
       calib_data_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[1].to_s + ']')
       calib_upper_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[2].to_s + ']')
       calib_lower_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[3].to_s + ']')
     end
    end
    @calib_data_out=calib_data_out_tmp.join(',')
    @calib_upper_out=calib_upper_out_tmp.join(',')
    @calib_lower_out=calib_lower_out_tmp.join(',')

    @data=likelihood_probs
    
    labels=likelihood_probs.length.times.collect { |x| (x * @likelihood_res +likelihood_start).round}
    
    result_one_sigma=@graph.scan(/ocd\[2\].likelihood.range\[1\](.*);/)
    result_one_sigma=result_one_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}
    one_sigma_dist=Array.new
    counter=0
    result_one_sigma.each do |range|
      unless range.blank?
        range = range.split(",").map{|value| value.to_f}
        one_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
        counter = counter + 1
      end
    end
    one_sigma_prob=Array.new
    one_sigma_dist.transpose.each_with_index do |one_sigma,i|
      one_sigma_prob[i]=one_sigma.include?(true) ? -(likelihood_probs.max/10) : 'null'
    end
    
    @one_sigma_range = one_sigma_prob

    result_two_sigma=@graph.scan(/ocd\[2\].likelihood.range\[2\](.*);/)
    result_two_sigma=result_two_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}
    
    two_sigma_dist=Array.new
    counter=0
    result_two_sigma.each do |range|
      unless range.blank?
        range = range.split(",").map{|value| value.to_f}
        two_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
        counter = counter + 1
      end
    end
    two_sigma_prob=Array.new
    two_sigma_dist.transpose.each_with_index do |two_sigma,i|
      two_sigma_prob[i]=two_sigma.include?(true) ? -(likelihood_probs.max/20) : 'null'
    end
    
    @two_sigma_range = two_sigma_prob
    
    @curve=@graph[/(calib\[0\].ref=\")(.*)(;\";)/,2]
    
    user_files_mask = File.join("#{Rails.root}/tmp/radon_calib*")

    user_files = Dir.glob(user_files_mask)

#    user_files.each do |file_location|
#      File.delete(file_location)
#    end
    
     
#     g = Gruff::Area.new('800x500')
#     g.title = "Probabilities for #{@sample.lab.name}-#{@sample.lab_nr}\n"+@log
#     g.title_margin=14*result_lines+14
#     g.hide_legend=true
#     Gruff::Base.const_set("LABEL_MARGIN",0)
#     g.title_font_size=14
#     g.theme = {
#       :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
#       :marker_color => '#aaa',
#       :background_colors => ['#eaeaea', '#fff']
#     }
#     g.theme_keynote
#     g.marker_font_size=14
#     g.draw_axis_labels
#     labelhash = {}
#     labelnumber=10
#     timespan=likelihood_probs.length*5
#     minimum = timespan / 10
#     magnitude = 10 * (Math.log(minimum) / Math.log(10)).floor
#     residual = minimum / magnitude
#     if residual > 5
#        tick = 10 * magnitude
#     elsif residual > 2
#        tick = 5 * magnitude
#     elsif residual > 1
#        tick = 2 * magnitude
#     else
#        tick = magnitude
#     end
     
#     tick=tick/5
#     labelindex=labelnumber.times.collect { |x| x * tick -((labels[0]/5) % tick)}
#     labelindex.each {|k|labelhash[k] = "|\n" + labels[k].to_s}
#     g.labels = labelhash
#     g.data("test", likelihood_probs,'#00000066')
#     g.data("test3", two_sigma_prob,'#00000066')
#     g.data("test2", one_sigma_prob,'#00000099')


#    send_data(g.to_blob, 
#            :disposition => 'inline', 
#            :type => 'image/png', 
#            :filename => "calibration.png")
    
#    render :text => '<pre>'+@graph+'<br>'+tick.to_yaml+'</pre>'
render :layout => false

  end
  
    def calibrate_multi
#    params[:ids]=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    order=params[:sort_by]
    @samples = Sample.order(order).where(id: params[:ids])

    out="Options(){RawData=TRUE};Plot(){"
    @samples.each do |sample|
      out<<"R_Date(\"#{sample.name}\",#{sample.bp},#{sample.std});"
    end
    out<<"};"
    File.open('tmp/radon_calib.oxcal', 'w') {|f| f.write(out) }
    `vendor/oxcal/OxCalLinux tmp/radon_calib.oxcal`

    @graph = File.read('tmp/radon_calib.js')
    first_sample_number=2
    @likelihood_start=[]
    @likelihood_res=[]
    @data=[]
    @likelihood_end=[]
    @one_sigma_range=[]
    @two_sigma_range=[]
    max_likelihood=[]
    
    @samples.each_with_index do |sample,i|
      sample_prefix="ocd[#{(i+first_sample_number).to_s}]."

      likelihood_start = @graph[/(#{Regexp.escape(sample_prefix)}likelihood.start=)(.*)(;)/,2].to_f

      @likelihood_start[i]=Time.mktime(likelihood_start)
      @likelihood_res[i] = @graph[/(#{Regexp.escape(sample_prefix)}likelihood.resolution=)(.*)(;)/,2].to_f
          
      likelihood_prob_string=@graph[/(#{Regexp.escape(sample_prefix)}likelihood.prob=\[)(.*)(\];)/,2]
      likelihood_prob_norm=@graph[/(#{Regexp.escape(sample_prefix)}likelihood.probNorm=)(.*)(;)/,2]
      likelihood_probs=likelihood_prob_string.split(', ').map{|prob| prob.to_f*likelihood_prob_norm.to_f}

      timespan=likelihood_probs.length * @likelihood_res[i]
      @likelihood_end[i] = Time.mktime(likelihood_start+timespan)
      
      labels=likelihood_probs.length.times.collect { |x| (x * @likelihood_res[i] +likelihood_start).round}

      max_likelihood[i]=likelihood_probs.max
      
      tmp_data=[]
      
      likelihood_probs.each_with_index do |likelihood,index|
        if index==0
          tmp_data.push('{name: "' + sample.lab.lab_code.to_s + '-' + sample.lab_nr.to_s + '", x: ' + (Time.mktime(labels[index]).to_i*1000).to_s + ',y:' + likelihood.to_s + '}')
        else
          tmp_data.push('{x: ' + (Time.mktime(labels[index]).to_i*1000).to_s + ', y:' + likelihood.to_s + '}')
        end
      end
      
#      @data[i]=likelihood_probs
      @data[i]=tmp_data
      
      result_one_sigma=@graph.scan(/#{Regexp.escape(sample_prefix)}likelihood.range\[1\](.*);/)

      result_one_sigma=result_one_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}

      one_sigma_dist=Array.new
      counter=0
      result_one_sigma.each do |range|
        unless range.blank?
          range = range.split(",").map{|value| value.to_f}
          one_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
          counter = counter + 1
        end
      end
      
      one_sigma_prob=Array.new
      one_sigma_dist.transpose.each_with_index do |one_sigma,index|
        one_sigma_prob[index]=one_sigma.include?(true) ? -(max_likelihood[i]/10) : 'null'
      end
      
      @one_sigma_range[i] = one_sigma_prob

      result_two_sigma=@graph.scan(/#{Regexp.escape(sample_prefix)}likelihood.range\[2\](.*);/)
      result_two_sigma=result_two_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}
      
      two_sigma_dist=Array.new
      counter=0
      result_two_sigma.each do |range|
        unless range.blank?
          range = range.split(",").map{|value| value.to_f}
          two_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
          counter = counter + 1
        end
      end
      two_sigma_prob=Array.new
      two_sigma_dist.transpose.each_with_index do |two_sigma,index|
        two_sigma_prob[index]=two_sigma.include?(true) ? -(max_likelihood[i]/20) : 'null'
      end
      
      @two_sigma_range[i] = two_sigma_prob
      
    end
    
    @curve=@graph[/(calib\[0\].ref=\")(.*)(;\";)/,2]
    
    user_files_mask = File.join("#{Rails.root}/tmp/radon_calib*")

    user_files = Dir.glob(user_files_mask)

    user_files.each do |file_location|
      File.delete(file_location)
    end
    
    @max_data=max_likelihood.max

    render :layout => false

  end
  
    def calibrate_sum
#    params[:ids]=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    order=params[:sort_by]
    @samples = Sample.order(order).where(id: params[:ids])
#    @sample_names_string = @samples.map(&:name).to_sentence
    out="Options(){RawData=TRUE};Plot(){Sum(){"
    @samples.each do |sample|
      out<<"R_Date(\"#{sample.name}\",#{sample.bp},#{sample.std});"
    end
    out<<"};};"
    File.open('tmp/radon_calib.oxcal', 'w') {|f| f.write(out) }
    `vendor/oxcal/OxCalLinux tmp/radon_calib.oxcal`
    @log = File.read('tmp/radon_calib.log')
    @graph = File.read('tmp/radon_calib.js')
    @log=@log.split("\n")[6..-1].join("\n")
    result_lines=@log.scan(/\n/).length
    @result_lines=result_lines
    likelihood_start = @graph[/(ocd\[2\].likelihood.start=)(.*)(;)/,2].to_f
#    @likelihood_start=Time.local(likelihood_start,1,1)
    @likelihood_start=Time.mktime(likelihood_start)
    @likelihood_res = @graph[/(ocd\[2\].likelihood.resolution=)(.*)(;)/,2].to_f
        
    likelihood_prob_string=@graph[/(ocd\[2\].likelihood.prob=\[)(.*)(\];)/,2]
    likelihood_prob_norm=@graph[/(ocd\[2\].likelihood.probNorm=)(.*)(;)/,2]
    likelihood_probs=likelihood_prob_string.split(', ').map{|prob| prob.to_f*likelihood_prob_norm.to_f}
    calib_cal_string=@graph[/(calib\[0\].rawcal=\[)(.*)(\];)/,2]
    @calib_cal=calib_cal_string.split(',').map{|prob| prob.to_f}
    calib_bp_string=@graph[/(calib\[0\].rawbp=\[)(.*)(\];)/,2]
    @calib_bp=calib_bp_string.split(',').map{|prob| prob.to_f}
    calib_sigma_string=@graph[/(calib\[0\].rawsigma=\[)(.*)(\];)/,2]
    @calib_sigma=calib_sigma_string.split(',').map{|prob| prob.to_f}

    timespan=likelihood_probs.length * @likelihood_res
    @likelihood_end = Time.mktime(likelihood_start+timespan)
    
    @calib_data=Array.new
    @calib_data[0]=@calib_cal
    @calib_data[1]=@calib_bp
    @calib_data[2]=@calib_bp.zip(@calib_sigma).map{ |pair| pair[0] + pair[1] }
    @calib_data[3]=@calib_bp.zip(@calib_sigma).map{ |pair| pair[0] - pair[1] }
    @calib_data=@calib_data.transpose
    
    @calib_data_out=String.new
    calib_data_out_tmp=Array.new
    calib_upper_out_tmp=Array.new
    calib_lower_out_tmp=Array.new
    
    @calib_data.each do |a|
     if ((a[0]>=likelihood_start) && ((likelihood_start + timespan) >=a[0]))
       calib_data_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[1].to_s + ']')
       calib_upper_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[2].to_s + ']')
       calib_lower_out_tmp.push('[' + (Time.mktime(a[0]).to_i*1000).to_s + ', ' + a[3].to_s + ']')
     end
    end
    @calib_data_out=calib_data_out_tmp.join(',')
    @calib_upper_out=calib_upper_out_tmp.join(',')
    @calib_lower_out=calib_lower_out_tmp.join(',')

    @data=likelihood_probs
    
    labels=likelihood_probs.length.times.collect { |x| (x * @likelihood_res +likelihood_start).round}
    
    result_one_sigma=@graph.scan(/ocd\[2\].likelihood.range\[1\](.*);/)
    result_one_sigma=result_one_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}
    one_sigma_dist=Array.new
    counter=0
    result_one_sigma.each do |range|
      unless range.blank?
        range = range.split(",").map{|value| value.to_f}
        one_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
        counter = counter + 1
      end
    end
    one_sigma_prob=Array.new
    one_sigma_dist.transpose.each_with_index do |one_sigma,i|
      one_sigma_prob[i]=one_sigma.include?(true) ? -(likelihood_probs.max/10) : 'null'
    end
    
    @one_sigma_range = one_sigma_prob

    result_two_sigma=@graph.scan(/ocd\[2\].likelihood.range\[2\](.*);/)
    result_two_sigma=result_two_sigma.collect{|x| x.to_s[/\[.*?\].*\[(.*?)\]/,1]}
    
    two_sigma_dist=Array.new
    counter=0
    result_two_sigma.each do |range|
      unless range.blank?
        range = range.split(",").map{|value| value.to_f}
        two_sigma_dist[counter] = labels.map{|label| label.between?(range[0],range[1])}
        counter = counter + 1
      end
    end
    two_sigma_prob=Array.new
    two_sigma_dist.transpose.each_with_index do |two_sigma,i|
      two_sigma_prob[i]=two_sigma.include?(true) ? -(likelihood_probs.max/20) : 'null'
    end
    
    @two_sigma_range = two_sigma_prob
    
    @curve=@graph[/(calib\[0\].ref=\")(.*)(;\";)/,2]
    
    user_files_mask = File.join("#{Rails.root}/tmp/radon_calib*")

    user_files = Dir.glob(user_files_mask)

    user_files.each do |file_location|
      File.delete(file_location)
    end

    render :layout => false

  end
  
  
  def export_chart
#    require 'active_support/secure_random'
    # create an SVG image
    # based on Highcharts index.php
    batik_path = Rails.root.to_s() + '/vendor/batik/batik-rasterizer.jar'
    
    svg = params[:svg]
    filename = params[:filename].blank? ? "chart" : params[:filename]
    
    if params[:type] == 'image/png' 
      type = '-m image/png';
      ext = 'png'
    elsif params[:type] == 'image/jpeg' 
      type = '-m image/jpeg'
      ext = 'jpg'
    elsif params[:type]  == 'application/pdf'
      type = '-m application/pdf'
      ext = 'pdf'
    elsif params[:type]  == 'image/svg+xml'
      type = '-m image/svg+xml'
      ext = 'svg'
    else
      show_error "unknown image type: #{params[:type]}"
    end
  
    # two random file names - one for Batik to read (with SVG XML) and one for it to write to
    tempname = SecureRandom.hex(16)
    outfile = "tmp/out_#{tempname}.#{ext}"
    infile = "tmp/in_#{tempname}.svg"
    tmppngfile = "tmp/#{tempname}.png"
    width = "-w #{params[:width]}" if params[:width]    
    
    File.open(infile, 'w') {|f| f.write(svg) }          # SVG definition for Batik to read

     # do the conversion
    if (params[:type]  == 'image/svg+xml')
      cmd = "cp #{infile} #{outfile}"
#      logger.info(cmd)
      rsp = system(cmd)
    elsif (params[:type]  == 'image/jpeg')
      cmd = "inkscape -f #{infile} #{width} -e #{tmppngfile}"
#      logger.info(cmd)
      rsp = system(cmd)
      cmd = "convert #{tmppngfile} #{outfile}"
#      logger.info(cmd)
      rsp = rsp & system(cmd)
      File.delete(tmppngfile)
    elsif (params[:type]  == 'image/png')
      cmd = "inkscape -f #{infile} #{width} -e #{outfile}"
#      logger.info(cmd)
      rsp = system(cmd)
    elsif (params[:type]  == 'application/pdf')
      cmd = "inkscape -f #{infile} -A #{outfile}"
#      logger.info(cmd)
      rsp = system(cmd)    
    end
      
     # For now, rely on existence and size of output file as an idicator of success
     fs = File.size?( outfile)
     if fs.nil? || fs < 10
       render :text => "Unable to export image; #{rsp}", :status => 500
    else       
      File.open(outfile, 'r') do |f|
        send_data f.read, :type => params[:type], :filename=> "#{filename}.#{ext}", :disposition => 'attachment'
      end
     end
     
     File.delete( infile, outfile)
  end

  protected

#  def set_site
#    unless ((params[:sample][:site_id].blank?) || (params[:site_id]=='undefined') ) 
#      @sample.site_id = params[:site_id]
#    else
#      unless params[:site_name].blank?
#        site=Site.new()
#        site.name=params[:site_name]
#        site.lat = params[:site_lat]
#        site.lng = params[:site_lng]

#        url = "http://ws.geonames.org" + "/countrySubdivisionJSON?a=a"
#        url = url + "&lat=#{site.lat}&lng=#{site.lng}"
#        uri = URI.parse(url)
#        req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
#        res = Net::HTTP.start( uri.host, uri.port ) { |http|
#          http.request( req )
#        }
#        doc = ActiveSupport::JSON.decode(res.body)
#        site_adm1_name=doc['adminName1'] || "n/a"
#        site_country_name=doc['countryName'] || "n/a"
#        site_country=Country.find_or_initialize_by_name(site_country_name)
#        site_country.abreviation=doc['countryCode']
#        site_country.save #neue Abkürzungen übernehmen!
#        country_subdivison_conditions = { 
#                 :country_id => site_country.id,
#                 :name => site_adm1_name }

#        country_subdivison = CountrySubdivision.first(:conditions => country_subdivison_conditions) || CountrySubdivision.new(country_subdivison_conditions)
#        site.country_subdivision=country_subdivison
#  #      site.save
#  #      @sample.site_id = site.id
#        @sample.site = site
#      else
#        flash[:error] = "Please specify site!"
#      end
#    end
#  end
end
