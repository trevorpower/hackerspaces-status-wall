delay = (t, f) -> setTimeout(f, t)

markers = {}

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
          markers[status.space] = L.marker([status.lat, status.lon])
            .addTo(map)
            .bindPopup(status.space)

    delay 1400, () ->
      layer = L.tileLayer $('link[rel=tiles]').attr('href'),
        attributionControl: false
      layer.addTo map

