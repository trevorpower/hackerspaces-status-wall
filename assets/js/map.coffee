delay = (t, f) -> setTimeout(f, t)

$ ->
  delay 1000, () ->

    map = L.map 'mapview',
      attributionControl: false

    map.setView [51.505, -0.09], 3

    layer = L.tileLayer 'http://{s}.tile.cloudmade.com/e15b62c19bf1450f9cbcf276aeec12ca/77568/256/{z}/{x}/{y}.png',
      attributionControl: false
    layer.addTo map

    L.marker([51.5, -0.09])
      .addTo(map)
      .bindPopup('A pretty CSS3 popup. <br> Easily customizable.')
      .openPopup()
