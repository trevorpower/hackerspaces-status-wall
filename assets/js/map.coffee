delay = (t, f) -> setTimeout(f, t)

primary1 = '#FB7A44'
primary2 = '#BC7455'
complement1 = '#2EAB79'
complement2 = '#3A8064'
complement5 = '#7FD5B2'

locationColor = primary1
openColor = complement2
closedColor = primary2

markers = {}

createMarker = (status) ->
  statusMarker = L.circleMarker [status.lat, status.lon],
    weight: 0
    fillColor: if status.open then openColor else closedColor
    fillOpacity: 1
    radius: if status.open then 14 else 11
  location = L.circleMarker [status.lat, status.lon],
    weight: 0
    fillColor: '#FFFFFF'
    fillOpacity: 1
    radius: 5

  L.featureGroup [statusMarker, location]


window.map = (socket) ->

  $ ->
    map = L.map 'mapview',
      attributionControl: false

    map.setView [23, -15], 2

    socket.on 'new status', (status) ->
      if status.lat and status.lon
        if markers[status.space]
          markers[status.space]
            .bindPopup(status.space)
        else
          markers[status.space] = createMarker(status)
            .addTo(map)
            .bindPopup(status.space)

    delay 1400, () ->
      layer = L.tileLayer $('link[rel=tiles]').attr('href'),
        attributionControl: false
      layer.addTo map

