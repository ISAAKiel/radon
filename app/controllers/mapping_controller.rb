class MappingController < ApplicationController
  include ApplicationHelper

#  include MapHelper

  def index
    show_map
  end
  
  def add_marker
    render :update do |page|
      @markers = JsVar.new('markers')
#      page << @markers.add_marker(OpenLayers::Marker.new(OpenLayers::LonLat.new(rand*50,rand*50)))

      Geonames::Weather.weather(:north => 44.1, :south => -9.9, :east => -22.4, :west => 55.2).each do |weather|
#        logger.debug weather.lat
        page << @markers.add_vector(OpenLayers::Vector.new(OpenLayers::LonLat.new(weather.lng,weather.lat)))
      end
    end
  end
  
  def search
#    render :update do |page|
#    @markers = JsVar.new('markers')
#    page << "map.events.remove('moveend');"
#    page << "selcontrol.unselectAll();"
#    out="
#    <script>
#    function zoomChanged ( ) {
#      selcontrol.unselectAll();
#      extent=map.getExtent();
#      extent=extent.transform(map.getProjectionObject(),proj);
#      new Ajax.Updater('search_results', '/mapping/search?format=js', {asynchronous:true, evalScripts:true, method:'get', parameters:'#{params.reject {|key,value| key == "BBOX" }.to_param}&BBOX='+extent.toBBOX()});
#    }

#    map.events.register( 'moveend', map, zoomChanged );
#    </script>"
#    unless params[:site_id].blank?
#      place = Site.first(:conditions=>{:id=>params[:site_id]})
#      counter=1
#      page << "var features = [];
#        var myPos=new OpenLayers.Geometry.Point(#{place.lng} , #{place.lat});
#        myPos=myPos.transform(proj, map.getProjectionObject());
#        var myMarker = new OpenLayers.Feature.Vector(myPos);
#        var MarkerId= '#{counter}';
#        var MarkerSiteName = '#{place.name}';
#        var MarkerName = '#{place.name}';
#        var MarkerSiteId = '#{place.id}';
#        var MarkerCountrySubdivisionName = '#{place.country_subdivision ? place.country_subdivision.name : nil }';
#        var MarkerCountrySubdivisionId = '#{place.country_subdivision ? place.country_subdivision.id : nil}';
#        var MarkerCountryName = '#{(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.name : nil }';
#        var MarkerCountryId = '#{(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.id : nil}';
#        myMarker.attributes = {
#                                name: MarkerName,
#                                siteName: MarkerSiteName,
#                                id: MarkerId,
#                                siteId: MarkerSiteId,
#                                countrySubdivisionName: MarkerCountrySubdivisionName,
#                                countrySubdivisionId: MarkerCountrySubdivisionId,
#                                countryName: MarkerCountryName,
#                                countryId: MarkerCountryId,
#                                fillColor:'#59B26B'
#                        };
#        features.push(myMarker);
#        markers.addFeatures(features);"

#          out << [counter.to_s,place.name,place.country_subdivision ? place.country_subdivision.name : "n.a.",(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.name : "n.a."].join(", ") + " | "
#          out << link_to_function("Zoom", " var myPos=new OpenLayers.LonLat(#{place.lng}, #{place.lat});
#                                            myPos=myPos.transform(proj, map.getProjectionObject());
#                                            map.setCenter(myPos, 15);") + " | "
#          out << link_to_function("Select", "externSelectFeature(#{counter})")
#          out << " | (actual site) <br>"
#          
#      if params[:BBOX].blank?
#        page << 'if (markers.getDataExtent()) {
#          map.zoomToExtent(markers.getDataExtent());}'
#      end
#      
#      page.replace_html 'results', out.html_safe

#    end
#    unless params[:search].blank?
#      search_string = Iconv.iconv('ascii//translit', 'utf-8', CGI.unescape(params[:search])).to_s
#      url = "http://ws.geonames.org" + "/searchJSON?a=a"
#      url = url + "&name=#{search_string.downcase}"
#      uri = URI.parse(URI.escape(url))
#      req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
#      res = Net::HTTP.start( uri.host, uri.port ) { |http|
#        http.request( req )
#      }
#      doc = ActiveSupport::JSON.decode(res.body)

#    page << 'markers.removeFeatures(markers.features);'
#    
#      unless params[:BBOX].blank?
#        bbox=params[:BBOX].split(",").map!{|x| x.to_f}
#      end
#    counter=0
#    known_sites= Site.find(:all,:conditions=>["lat is not NULL AND lng is not NULL AND lower(name) like ?", '%'+CGI.unescape(params[:search]).downcase+'%'])
#    known_sites.each do |place|
#          counter += 1
#          page << "var features = [];
#                  var myPos=new OpenLayers.Geometry.Point(#{place.lng} , #{place.lat});
#                  myPos=myPos.transform(proj, map.getProjectionObject());
#                  var myMarker = new OpenLayers.Feature.Vector(myPos);
#                  var MarkerId= '#{counter}';
#                  var MarkerSiteName = '#{place.name}';
#                  var MarkerName = '#{place.name}';
#                  var MarkerSiteId = '#{place.id}';
#                  var MarkerCountrySubdivisionName = '#{place.country_subdivision ? place.country_subdivision.name : nil }';
#                  var MarkerCountrySubdivisionId = '#{place.country_subdivision ? place.country_subdivision.id : nil}';
#                  var MarkerCountryName = '#{(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.name : nil }';
#                  var MarkerCountryId = '#{(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.id : nil}';
#                  myMarker.attributes = {
#                                          name: MarkerName,
#                                          siteName: MarkerSiteName,
#                                          id: MarkerId,
#                                          siteId: MarkerSiteId,
#                                          countrySubdivisionName: MarkerCountrySubdivisionName,
#                                          countrySubdivisionId: MarkerCountrySubdivisionId,
#                                          countryName: MarkerCountryName,
#                                          countryId: MarkerCountryId,
#                                          fillColor:'#59B26B'
#                                  };
#                  features.push(myMarker);
#                  markers.addFeatures(features);"

#          out << [counter.to_s,place.name,place.country_subdivision ? place.country_subdivision.name : "n.a.",(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.name : "n.a."].join(", ") + " | "
#          out << link_to_function("Zoom", " var myPos=new OpenLayers.LonLat(#{place.lng}, #{place.lat});
#                                            myPos=myPos.transform(proj, map.getProjectionObject());
#                                            map.setCenter(myPos, 15);") + " | "
#          out << link_to_function("Select", "externSelectFeature(#{counter})")
#          out << " | (already in DB) <br>"            
#    end
#    
#    doc["geonames"].each do |place|

##      if place['fcode']=='PPL'
#      unless (place['lng'].blank? || place['lat'].blank?) || (known_sites.detect { |e| e.lat==place['lat'] && e.lng == place['lng']})# || place['fcode'][0..2]!='PPL')
#        if ((params[:BBOX].blank?) || ((bbox[0]<=place['lng']) && (place['lng']<=bbox[2]) &&  (bbox[1]<=place['lat']) && (place['lat']<=bbox[3]))) # Wenn lat und lng gegeben und noch nicht in DB
#          counter += 1

#          #mögliches Javascript in Namen maskieren
#          place['name']=escape_javascript(place['name'])
#          place['adminName1']=escape_javascript(place['adminName1'])
#          place['countryName']=escape_javascript(place['countryName'])
#          page << "var features = [];
#                  var myPos=new OpenLayers.Geometry.Point(#{place['lng']} , #{place['lat']});
#                  myPos=myPos.transform(proj, map.getProjectionObject());
#                  var myMarker = new OpenLayers.Feature.Vector(myPos);
#                  var MarkerId= '#{counter}';
#                  var MarkerSiteName = '#{place['name']}';
#                  var MarkerName = '#{[place['name'], place['adminName1'], place['countryName']].join(", ")}';
#                  var MarkerCountrySubdivisionName = '#{place['adminName1']}';
#                  var MarkerCountryName = '#{place['countryName']}';
#                  myMarker.attributes = {
#                                          name: MarkerName,
#                                          siteName: MarkerSiteName,
#                                          id: MarkerId,
#                                          countrySubdivisionName: MarkerCountrySubdivisionName,
#                                          countryName: MarkerCountryName,
#                                          fillColor:'#ee9900'
#                                  };
#                  features.push(myMarker);
#                  markers.addFeatures(features);"

#          out << [counter.to_s,place['name'], place['adminName1'], place['countryName']].join(", ") + " | "
#          out << link_to_function("Zoom", " var myPos=new OpenLayers.LonLat(#{place['lng']}, #{place['lat']});
#                                            myPos=myPos.transform(proj, map.getProjectionObject());
#                                            map.setCenter(myPos, 15);") + " | "
#          out << link_to_function("Select", "externSelectFeature(#{counter})")
#          out << "<br>"
#        end
#      end     

#    end unless doc["geonames"].blank?
#    out <<  link_to_remote("Show all results", :update => "search_results", :url => { :action => "search", :search=>params[:search] }, :method=>:get)
#    
#    if params[:BBOX].blank?
#      page << 'if (markers.getDataExtent()) {
#        map.zoomToExtent(markers.getDataExtent());}'
#    end
#    
#    page.replace_html 'results', out

#    end
#    end
  end
  
  def set
    render :update do |page|
#      page << "map.events.remove('moveend');"
      page << "selcontrol.unselectAll();"
      page << 'markers.removeFeatures(markers.features);'
      page << "var myPos=new OpenLayers.Geometry.Point(#{params[:enter_lng]}, #{params[:enter_lat]});
                  myPos=myPos.transform(proj, map.getProjectionObject());
                  var myMarker = new OpenLayers.Feature.Vector(myPos,{name:'new',id:'1'});"
		page << "map.setCenter(new OpenLayers.LonLat(#{params[:enter_lng]}, #{params[:enter_lat]}).transform(proj, map.getProjectionObject()));"
      page << "markers.addFeatures(myMarker);"
      page << "externSelectFeature(1);"
      page << "$('feature_name_1').update('Name:" + text_field_tag(:site_tmp_name, params[:site_name]) + "');"
      page << 'markers.features[getFeatureIndexById(1)].popup.updateSize();'
    end
  end
  def draw
    render :update do |page|
      page << '$("results").update()'
      page << "map.events.remove('moveend');"
      page << "selcontrol.unselectAll();"
      page << 'markers.removeFeatures(markers.features);'
      page << 'draw.activate();'
      page << 'document.body.style.cursor = "crosshair"; $("map").style.cursor = "crosshair";'
      page << '
            var feature;

            markers.events.register("featureadded", feature, function(evt){
            //only one circle at a time
            var newFeature=markers.features[0]
            selcontrol.select(newFeature);
            markers.events.remove("featureadded");
            draw.deactivate();
            document.body.style.cursor = "auto";; $("map").style.cursor = "auto";'
      page << "$('feature_name_undefined').update('Name:" + text_field_tag(:site_tmp_name, params[:site_name]) + "')"
      page << 'newFeature.popup.updateSize();'
      page << '});//end after feature'
    end
  end
end
