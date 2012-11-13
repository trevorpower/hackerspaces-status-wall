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
      layer = L.tileLayer 'http://{s}.tile.cloudmade.com/e15b62c19bf1450f9cbcf276aeec12ca/77568/256/{z}/{x}/{y}.png',
        attributionControl: false
      layer.addTo map

