jQuery ->
  $("[data-input='site_country']").parent().show()
  $('.javascript_content').show()

  if !($("[data-input='site_country_subdivision'] option:selected").val())
    $("[data-input='site_country_subdivision']").parent().hide()

  states = $("[data-input='site_country_subdivision']").html()
  $("[data-input='site_country']").change ->
    country = $("[data-input='site_country'] :selected").text()
    escaped_country = country.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(states).filter("optgroup[label='#{escaped_country}']").html()
    if options
      $("[data-input='site_country_subdivision']").html(options)
      $("[data-input='site_country_subdivision']").parent().show()
    else
      $("[data-input='site_country_subdivision']").empty()
      $("[data-input='site_country_subdivision']").parent().hide()

  $("[data-input='site_lat']").change ->
    if ($("[data-input='site_lat']").val() && $("[data-input='site_lng']").val())
      coordinates_changed()
  $("[data-input='site_lng']").change ->
    if ($("[data-input='site_lat']").val() && $("[data-input='site_lng']").val())
      coordinates_changed()

  if ($("[data-input='site_lat']").val() && $("[data-input='site_lng']").val())
    coordinates_changed()

  $(".zoomToFeature").click ->
    zoomToFeature this.getAttribute ("data_id")
    false
  $(".selectFeature").click ->
#    clear_site_id()
    selectFeature this
    false

clear_site_id = ->
  if ($('#hidden_site_id').length != 0)
    $('#hidden_site_id').val('')
    $('#hidden_site_id').prop('disabled', true)
    $('.name-hint').remove()
    $("[data-input='site_name']").after('<p class="inline-warnings name-hint">Please Check, if name is still valid.</p>')

coordinates_changed = ->
#  clear_site_id()
  if ($("[data-input='site_lat']").val()>180 || $("[data-input='site_lat']").val()< -180)
    $('.coordinate_error').remove()
    $("[data-input='site_lat']").after('<p class="coordinate_error inline-errors">Invalid coordinate.</p>')
  else if ($("[data-input='site_lng']").val()>180 || $("[data-input='site_lng']").val()< -180)
    $('.coordinate_error').remove()
    $("[data-input='site_lng']").after('<p class="coordinate_error inline-errors">Invalid coordinate.</p>')
  else
    $('.coordinate_error').remove()
    proj=new OpenLayers.Projection "EPSG:4326"
    lat = parseFloat($("[data-input='site_lat']").val())
    lng = parseFloat($("[data-input='site_lng']").val())
    myPos=new OpenLayers.Geometry.Point( lng, lat )
    myPos=myPos.transform proj, @mymap.getProjectionObject()
    myFeature = new OpenLayers.Feature.Vector myPos
    myFeature.attributes = {
  #                          name: FeatureName,
  #                          siteName: FeatureSiteName,
                             id: 'New Site',
                             lat: lat,
                             lng: lng,
  #                          siteId: FeatureSiteId,
  #                          countrySubdivisionName: FeatureCountrySubdivisionName,
  #                          countrySubdivisionId: FeatureCountrySubdivisionId,
  #                          countryName: FeatureCountryName,
  #                          countryId: FeatureCountryId
                             fillColor: "#ee0000"
                    };
#    features.push(myFeature)
    @mymap.getControlsBy("id", 'proposed_features_select')[0].unselectAll()
    markerslayer = @mymap.getLayersByName('latlngentered_features')[0];
    markerslayer.destroyFeatures();
    markerslayer.addFeatures([myFeature])


@MarkOnce = OpenLayers.Class OpenLayers.Control,
defaultHandlerOptions:
  'single': true
  'double': false
  'pixelTolerance': 0
  'stopSingle': false
  'stopDouble': false

initialize: ->
  this.handlerOptions = OpenLayers.Util.extend({}, this.defaultHandlerOptions)
  OpenLayers.Control.prototype.initialize.apply(this, arguments)
#  this.handler = new OpenLayers.Handler.Click(this, {'click': this.mark},     this.handlerOptions)

mark: (evt) ->
  console.log 'mark'
  alert('pan')


default_marker = (lonlat) ->
  size = new OpenLayers.Size(21,25)
  offset = new OpenLayers.Pixel(-(size.w/2), -size.h)
  icon = new OpenLayers.Icon('http://www.openlayers.org/dev/img/marker.png',size,offset)
  marker = new OpenLayers.Marker(lonlat,icon)
  return marker

@initMap = (lon,lat,marker) ->
  @mymap = load_map(lon,lat)
  render_marker(@mymap,lon,lat) if marker
  set_projection(@mymap,lon,lat)
  set_callbacks(@mymap)
  @mymap.zoomToMaxExtent();

load_map = (lon,lat) ->
 map = new OpenLayers.Map 'map'
 layer = new OpenLayers.Layer.OSM();
 map.addLayer(layer)

 style=new OpenLayers.StyleMap({'default':{
                    strokeOpacity: 1,
                    strokeWidth: 1,
                    fillColor: "${fillColor}",
                    fillOpacity: 0.5,
                    pointRadius: 8,
                    pointerEvents: "visiblePainted",
                    label : "${id}",
                    fontColor: "#000000",
                    fontSize: "8px",
                    fontWeight: "bold",
                    labelAlign: "cm",
                    labelOutlineColor: "white",
                    labelOutlineWidth: 1
                }, 'select': {
                    fillColor:'#ee0000',
                    graphicZIndex: 10000
                }
            });
 proposed_features = new OpenLayers.Layer.Vector "proposed_features", {rendererOptions: { zIndexing: true }, styleMap: style}
 map.addLayer(proposed_features)

 selectCtrl = new OpenLayers.Control.SelectFeature(proposed_features,
                {clickout: true}
            )
 selectCtrl.id = 'proposed_features_select'
 proposed_features.events.on({
     "featureselected": (event) ->
         clear_site_id()
         console.log event.feature.data
         if event.feature.data.siteId != ''
           $('#hidden_site_id').val(event.feature.data.siteId)
           $('#hidden_site_id').prop('disabled', false);
         latlngentered_features.destroyFeatures()
         $("[data-input='site_lat']").val(event.feature.data.lat)
         $("[data-input='site_lng']").val(event.feature.data.lng)
         $("[data-input='site_country']").val("")
         $("[data-input='site_country_subdivision']").val("")
         $("[data-input='site_country'] option:contains(" + event.feature.data.countryName + ")").attr('selected', 'selected')
         $("[data-input='site_country']").change()
         $("[data-input='site_country_subdivision'] option:contains(" + event.feature.data.countrySubdivisionName + ")").attr('selected', 'selected')
     "featureunselected": (event) ->
         clear_site_id()
 });

 map.addControl(selectCtrl)
 selectCtrl.activate()

 tempLayer = new OpenLayers.Layer.Vector "Temp Layer", {styleMap: style}

 latlngentered_features = new OpenLayers.Layer.Vector "latlngentered_features", {rendererOptions: { zIndexing: true }, styleMap: style}

 featureDrawn = (object) ->
   drawControl.deactivate()
   selectCtrl.activate()
   selectCtrl.unselectAll()
   latlngentered_features.destroyFeatures()
   proj=new OpenLayers.Projection "EPSG:4326"
   pos_orig = object.feature.geometry.getBounds().getCenterLonLat()
   mypos= new OpenLayers.LonLat(pos_orig.lon, pos_orig.lat).transform @mymap.getProjectionObject(), proj
   new_feature_attributes = {
    fillColor:'#ee0000',
    id: 'New Site',
    lat: mypos.lat,
    lng: mypos.lon
   }

   new_feature = new OpenLayers.Feature.Vector new OpenLayers.Geometry.Point(pos_orig.lon, pos_orig.lat), new_feature_attributes
   $("[data-input='site_lat']").val(mypos.lat)
   $("[data-input='site_lng']").val(mypos.lon)
   latlngentered_features.addFeatures([new_feature])
   tempLayer.destroyFeatures()

 drawControl = new OpenLayers.Control.DrawFeature tempLayer, OpenLayers.Handler.Point
 drawControl.events.register('featureadded', drawControl, (feature) -> featureDrawn(feature))

 drawControl.id = 'tempLayer_features_draw'

 map.addControl(drawControl)

 @activateDraw = () ->
   $('html').click (event) ->
     if !($('#draw_site').is(event.target))
       drawControl.deactivate()
     return true
   $('#map').click (event) ->
     event.stopPropagation()
   drawControl.activate()
   selectCtrl.deactivate()
 map.addLayer(latlngentered_features)
 map.addLayer(tempLayer)
 map

set_projection = (map, lon, lat) ->
 projection = new OpenLayers.Projection("EPSG:4326")
 point = new OpenLayers.LonLat(lon,lat)
 center = point.transform(projection, map.getProjectionObject())
 map.setCenter(point, 5)

render_marker = (map,lon,lat) ->
 layer_once = new OpenLayers.Layer.Markers("mark_once")
 map.addLayer(layer_once)

 lonlat = new OpenLayers.LonLat(lon,lat)
 layer_once.addMarker(@default_marker(lonlat))
 @numMarkers++

set_callbacks = (map) ->
 click = new MarkOnce()
 map.addControl(click)
 click.activate()

@populateMap = (places) ->
  proposed_features = []
  proj=new OpenLayers.Projection "EPSG:4326"
  for place in places
    
    myPos=new OpenLayers.Geometry.Point(place['lng'], place['lat'])
    myPos=myPos.transform proj, @mymap.getProjectionObject()
    FeatureId= place['id']
  #  FeatureSiteName = '#{place.name}'
  #  FeatureName = '#{place.name}'
  #  FeatureSiteId = '#{place.id}'
    FeatureCountrySubdivisionName = place['adminName1']
  #  FeatureCountrySubdivisionId = '#{place.country_subdivision ? place.country_subdivision.id : nil}'
    FeatureCountryName = place['countryName']
  #  FeatureCountryId = '#{(place.country_subdivision && place.country_subdivision.country) ? place.country_subdivision.country.id : nil}'
    FeatureSiteId = ''
    if place['source'] == 'geonames'
      fill = '#59B26B'
    if place['source'] == 'sites'
      fill = '#ee9900'
      FeatureSiteId = place['site_id']
    attributes = {
#                          name: FeatureName,
#                          siteName: FeatureSiteName,
                          id: FeatureId,
                          lat: place['lat'],
                          lng: place['lng'],
                          siteId: FeatureSiteId,
                          countrySubdivisionName: FeatureCountrySubdivisionName,
#                          countrySubdivisionId: FeatureCountrySubdivisionId,
                          countryName: FeatureCountryName,
#                          countryId: FeatureCountryId,
                          fillColor: fill
                  };

    myFeature = new OpenLayers.Feature.Vector myPos, attributes
    proposed_features.push(myFeature)
  markerslayer = @mymap.getLayersByName('proposed_features')[0]
  markerslayer.addFeatures(proposed_features)

@zoomToFeature= (id) ->
   layer = @mymap.getLayersByName('proposed_features')[0]
   feature=layer.getFeaturesByAttribute("id", parseInt(id))[0]
   @mymap.zoomToExtent(feature.geometry.getBounds(), closest=true)

@selectFeature= (element) ->
   id = element.getAttribute ("data_id")
   layer = @mymap.getLayersByName('proposed_features')[0]
   feature=layer.getFeaturesByAttribute("id", parseInt(id))[0]
   markerslayer = @mymap.getLayersByName('latlngentered_features')[0];
   markerslayer.destroyFeatures();
   selectControl=@mymap.getControlsBy("id", 'proposed_features_select')[0]
   selectControl.unselectAll()
   selectControl.select(feature)
