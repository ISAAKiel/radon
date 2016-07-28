jQuery ->
  if $('.sites.show').length > 0

    data = $('#map').data('sites');

    # create map
    map = L.map('map', {maxZoom: 20}).setView([
        data['lat']
        data['lng']
      ], 15)

    googleLayer = new L.Google('HYBRID')
    map.addLayer(googleLayer, maxZoom: 18)

    L.marker([
      data['lat']
      data['lng']
    ]).addTo map

