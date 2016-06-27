# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	require 'digest/sha1'

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

	def generate_html_id
		Digest::SHA1.hexdigest Time.now.to_s + rand().to_s
	end

#  def link_to_remove_fields(name, f)
#    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)").html_safe
#  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s + "/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def auto_complete_with_hidden_field(name, f, association)
  
  	 this_id=generate_html_id

#    auto_complete_name=this_id+"_auto_complete"
    auto_complete_name="auto_complete_"+this_id
    
    hidden_name = (association.to_s + "_id").to_sym

    update_hidden_field = "fill_hidden_field(this);"
    
    fields = (text_field_with_auto_complete auto_complete_name, association, { :size => 15, :onblur => update_hidden_field}, { :url => literatures_samples_path, :format=>:js, :method => :get, :param_name => 'auto_complete_'+association.to_s, :skip_style => true}) + 
    (f.input hidden_name, :as => :hidden)
    return fields
  end

 def markdown(text)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, options).render(text).html_safe
  end

  def index_table_links(association)
    links = []
    if permitted_to?(:show,association) then
      links.push(
        link_to "Show",association, :class => 'btn btn-default btn-xs'
      )
    end
    if permitted_to?(:edit,association) then
      links.push(
        link_to t('.edit', :default => t("helpers.links.edit")), edit_polymorphic_path(association), :class => 'btn btn-default btn-xs'
      )
    end
    if permitted_to?(:destroy,association) then
      links.push(
        link_to t('.destroy', :default => t("helpers.links.destroy")),
              polymorphic_path(association),
              :method => 'delete',
              :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
              :class => 'btn btn-danger btn-xs'
      )
    end
    if ((association.class == Sample) && (permitted_to?(:calibrate,association))) then
      links.push(
        link_to "Calibrate", url_for(:action => 'calibrate', :controller => 'samples', :id => association), 'data-popup' => true, class: "btn btn-info btn-xs"
      )
    end
    links.join(" ").html_safe
  end

  def edit_view_links(association)
    links = []
    if permitted_to?(:show,association) then
      links.push(
        link_to "Show",association, :class => 'btn btn-default'
      )
    end
    if permitted_to?(:index,association) then
      links.push(
        link_to t('.back', :default => t("helpers.links.back")),
              eval("#{association.class.name.underscore.pluralize}_path"), :class => 'btn btn-default'
      )
    end
    links.join(" ").html_safe
  end

  def show_view_links(association)
    links = []
    if ((association.class == Sample) && (permitted_to?(:calibrate,association))) then
      links.push(
        link_to "Calibrate", url_for(:action => 'calibrate', :controller => 'samples', :id => association), 'data-popup' => true, class: "btn btn-info"
      )
    end
    if permitted_to?(:index,association) then
      links.push(
        link_to t('.back', :default => t("helpers.links.back")),
              eval("#{association.class.name.underscore.pluralize}_path"), :class => 'btn btn-default'
      )
    end
    if permitted_to?(:edit,association) then
      links.push(
        link_to t('.edit', :default => t("helpers.links.edit")), edit_polymorphic_path(association), :class => 'btn btn-default'
      )
    end
    if permitted_to?(:destroy,association) then
      links.push(
        link_to t('.destroy', :default => t("helpers.links.destroy")),
              polymorphic_path(association),
              :method => 'delete',
              :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
              :class => 'btn btn-danger'
      )
    end
    links.join(" ").html_safe
  end

  def is_admin?
    current_user.is_admin?
  end
    
  def show_map
      @map='<script defer="defer" type="text/javascript">'

      @map << 'var map;'

      @map << 'map = new OpenLayers.Map("map", {theme : false,projection : "new OpenLayers.Projection(\"EPSG:900913\")",displayProjection : "new OpenLayers.Projection(\"EPSG:4326\")"});'
      @map << 'var ghyb = new OpenLayers.Layer.Google(
              "Google Hybrid",{
                type: google.maps.MapTypeId.HYBRID,
                numZoomLevels: 20,
                "sphericalMercator": true,
                "maxExtent": new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34)}
              );
              var proj = new OpenLayers.Projection("EPSG:4326");'
      @map << 'var defaultStyle = new OpenLayers.Style({
        strokeColor: "${fillColor}",
        strokeOpacity: 1,
        strokeWidth: 1,
        fillColor: "${fillColor}",
        fillOpacity: 0.4,
        pointRadius:6,
        label: "${id}"
       });

var selectStyle = new OpenLayers.Style({
        fillColor: "#ff0000",
  pointRadius:8
});

var mapStyle = new OpenLayers.StyleMap({"default": defaultStyle,
                         "select": selectStyle});
      var renderer = OpenLayers.Util.getParameters(window.location.href).renderer;
renderer = (renderer) ? [renderer] : OpenLayers.Layer.Vector.prototype.renderers;
var markers = new OpenLayers.Layer.Vector("Markers",{
  styleMap: mapStyle,
renderers: renderer,
strategies: [new OpenLayers.Strategy.Fixed()],
protocol: new OpenLayers.Protocol.HTTP({
    url: "/mapping/search",
    format: new  OpenLayers.Format.JSON()
})
});

function createPopup(feature) {
feature.popup = new OpenLayers.Popup.AnchoredBubble("pop",
feature.geometry.getBounds().getCenterLonLat(),
null,
"<div><span id=\'feature_name_" + feature.attributes.id + "\'>name: "+feature.attributes.name+"</div> <br>id:" +feature.attributes.id+ "<br>' + '<input type=\'button\' value=\'Choose Site\' class=\'popup_closebox\' onclick=\'siteChoose();\'>'+ '<span class=\'name\' style=\'display:none;\'>"+feature.attributes.siteName+"</span><span class=\'site_lat\' style=\'display:none;\'>"+ feature.geometry.x +"</span><span class=\'site_lng\' style=\'display:none;\'>"+ feature.geometry.y +"</span></div>" ,
null,
true,
function() { selcontrol.unselectAll(); }
);
feature.popup.autoSize = true;
map.addPopup(feature.popup);
}

function destroyPopup(feature) {
feature.popup.destroy();
feature.popup = null;
} 

var selcontrol = new OpenLayers.Control.SelectFeature(
markers,
{
onSelect: createPopup,
onUnselect: destroyPopup
}
);
map.addControl(selcontrol);
selcontrol.activate();

function getFeatureIndexById(featureId)
{
  var objFs = markers.features;
  for(var i=0; i<objFs.length; ++i) {
    if(objFs[i].attributes.id == featureId) {
      idx = i;
      break;
    }
  }
  return idx;
}
function externSelectFeature(id)
{
var vlyr = markers;
selcontrol.unselectAll();
selcontrol.select(vlyr.features[getFeatureIndexById(id)]);
}
var container = document.getElementById("panel");
var draw = new OpenLayers.Control.DrawFeature(
    markers, OpenLayers.Handler.Point, {div: container}
);
        map.addControl(draw);'.html_safe

    @map << 'map.addLayers([ghyb, markers]);'

    @map << 'map.zoomToMaxExtent();'
    @map << '</script>'
  end
  
end
