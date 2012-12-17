#= require vendor/leaflet.js
#= require vendor/leaflet.markercluster.js

delay = (t, f) -> setTimeout(f, t)

primary1 = '#FB7A44'
primary2 = '#BC7455'
primary3 = '#A34016'
complement1 = '#2EAB79'
complement2 = '#3A8064'
complement3 = '#0F6F48'
complement5 = '#7FD5B2'

locationColor = primary1
openColor = complement3
closedColor = primary3

markers = {}
tweets = []

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

tweetMarker = (tweet) ->
  L.circleMarker tweet.coordinates.coordinates.reverse(),
    weight: 0
    fillColor: '#114169'
    fillOpacity: 1
    radius: 3

window.map = (socket) ->

  $ ->
    map = L.map 'mapview',
      attributionControl: false
      scrollWheelZoom: false

    map.setView [23, -15], 2

    map.zoomControl.setPosition 'bottomright'

    $('.leaflet-control-zoom-in').html '+'
    $('.leaflet-control-zoom-out').html '-'

    socket.on 'new status', (status) ->
      if status.lat and status.lon
        if markers[status.space]
          map.removeLayer markers[status.space]

        markers[status.space] = createMarker(status)
          .addTo(map)
          .bindPopup(status.space)

    addTweetToMap = (tweet) ->
      if tweet.coordinates
        marker = tweetMarker(tweet)
        marker.addTo(map)
        tweets.push marker
      else
        tweets.push null

    socket.on 'previous tweet', addTweetToMap
    socket.on 'new tweet', (data) ->
      addTweetToMap(data)
      map.removeLayer tweets[0] if tweets[0]
      tweets.shift()
   

    delay 1400, () ->
      layer = L.tileLayer $('link[rel=tiles]').attr('href'),
        attributionControl: false
      layer.addTo map

