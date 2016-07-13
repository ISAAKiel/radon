jQuery ->
  $('#sample_culture_id').parent().show()
  $('.javascript_content').show()

  if !($('#sample_phase_id option:selected').val())
    $('#sample_phase_id').parent().hide()

  states = $('#sample_phase_id').html()
  $('#sample_culture_id').change ->
    culture = $('#sample_culture_id :selected').text()
    escaped_culture = culture.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(states).filter("optgroup[label='#{escaped_culture}']").html()
    if options
      $('#sample_phase_id').html(options)
      $('#sample_phase_id').parent().show()
    else
      $('#sample_phase_id').empty()
      $('#sample_phase_id').parent().hide()

#  $(".siteFeature").click ->
#    $('#hidden_site_id').val(this.getAttribute ('data_site_id'))
##    $('#sample_site_id').val(this.getAttribute ("data_site_id"))
#    $('#hidden_site_id').prop('disabled', false);
#    console.log $('#hidden_site_id') 
#    false

  $("#search").keydown= (event) ->
    if(event.keyCode == 13 && jQuery.support.submitBubbles)
      $(this).parents("form").append('&commit=Search').submit();

  $("[data-function='use_last_site']").click (e) ->
    console.log this
    $('#hidden_site_id').val(this.getAttribute ('data_site_id'))
    $('#site_display_name').text(this.getAttribute ('data_site_name'))
    $("[data-input='site_name']").val(this.getAttribute ('data_site_name'))
    false

  $(document).on 'click', 'form .remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  getQueryParam = (param) ->
    regex = new RegExp("[?&]#{encodeURIComponent(param)}=([^&]*)")
    match = regex.exec(location.search)
    if match?
      decodeURIComponent(match[1])
    else
      null

  # set map center
  recreate_bbox = ->
    bbox_array = getQueryParam("bbox").split(",")
    bounds = [
      [bbox_array[0], bbox_array[1]]
      [bbox_array[2], bbox_array[3]]
    ]
    alert("nord" + bbox_array[3] + "o" + bbox_array[1] + "s" + bbox_array[2] + "w" + bbox_array[0])
    L.rectangle(bounds, {color: '#000000'}).addTo(drawnItems)
    map.addLayer drawnItems
    map.fitBounds(bounds)

  # create map
  map = L.map('map').setView([
    48.856
    2.35
  ], 13)

  # add tile layer 
  tileurl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  tileattribution = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'

  L.tileLayer(tileurl, 
    attribution: tileattribution
    maxZoom: 18).addTo map

  # add drawing layer
  drawnItems = new (L.FeatureGroup)

  recreate_bbox() if /bbox/.test(window.location.href)

  # add drawing controls
  drawControl = new (L.Control.Draw)(
    draw:
      polyline: false
      polygon: false 
      rectangle: true
      marker: false
      circle: false
    edit:
      featureGroup: drawnItems)
  map.addControl drawControl

  # change colour of drawn rectangles
  drawControl.setDrawingOptions rectangle: shapeOptions: color: '#000000'

  # react to user starting to draw
  map.on 'draw:drawstart', (e) ->
    if map.hasLayer drawnItems
      drawnItems.eachLayer (layer) ->
        do drawnItems.removeLayer layer
      return
    map.addLayer drawnItems
    return

  # react to user drawing
  map.on 'draw:created', (e) ->
    layer = e.layer
    coturl(layer)
    drawnItems.addLayer layer
    return

  # react to editing
  map.on 'draw:edited', (e) ->
    layers = e.layers
    layers.eachLayer (layer) ->
      coturl(layer)
      return
    return

  # coordinates to url method
  coturl = (layer) ->
    ll = layer.getBounds()
    north = ll.getNorth()
    east = ll.getEast()
    west = ll.getWest()
    south = ll.getSouth()
    coordtext = "?" + "bbox=" + north + "," + east + "," + south + "," + west
    stateObj = foo: 'bar'
    history.pushState stateObj, 'page 2', coordtext
    window.location = coordtext
    return
