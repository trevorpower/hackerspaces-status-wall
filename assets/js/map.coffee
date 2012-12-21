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

clusters = null

#createMarker = (status) ->
  #statusMarker = L.circleMarker [status.lat, status.lon],
  #  weight: 0
  #  fillColor: if status.open then openColor else closedColor
  #  fillOpacity: 1
  #  radius: if status.open then 14 else 11
  #location = L.circleMarker [status.lat, status.lon],
  #  weight: 0
  #  fillColor: '#FFFFFF'
  #  fillOpacity: 1
  #  radius: 5
  #
  #location
  #L.featureGroup [statusMarker, location]
  #statusMarker
  #L.marker [status.lat, status.lon]

tweetMarker = (tweet) ->
  L.circleMarker tweet.coordinates.coordinates.reverse(),
    weight: 0
    fillColor: '#114169'
    fillOpacity: 1
    radius: 3

sizeName = (num) ->
  switch num
    when 0 then 'zero'
    when 1 then 'one'
    when 2 then 'two'
    when 3 then 'three'
    else
      if num <= 5 then 'five'
      else if num <= 8 then 'eight'
      else if num <= 13 then 'thirteen'
      else if num <= 21 then 'twentyone'
      else if num <= 34 then 'thirtyfour'
      else if num <= 55 then 'fiftyfive'
      else if num <= 89 then 'eightynine'
      else if num <= 144 then 'onefourfour'
      else if num <= 233 then 'twothreethree'
      else if num <= 377 then 'threesevenseven'
      else 'thousand'
    
clusterIcon = (cluster) ->
  markers = cluster.getAllChildMarkers()
  total = markers.length
  opened = markers.filter((s) -> s.space.status == true).length
  closed = markers.filter((s) -> s.space.status == false).length
  L.divIcon
    iconSize: new L.Point(78, 24)
    html: """
          <span class='open #{sizeName opened}'>#{opened}</span>
          <span class='total #{sizeName total}'>#{total}</span>
          <span class='close #{sizeName closed}'>#{closed}</span>
          """
    className: 'cluster'

spaceMarker = (space) ->
  marker = L.marker space.location,
    weight: 0
    fillColor: '#EEEEEE'
    fillOpacity: 1
    radius: 2
    icon: L.divIcon(html: '.', className: 'location')
    
spaceId = (name) ->
  name.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-/, '')
    .replace(/-$/, '')
    
window.map = (socket) ->

  $ ->
    map = L.map 'mapview',
      attributionControl: false
      scrollWheelZoom: false

    map.setView [23, -15], 2

    map.zoomControl.setPosition 'bottomright'

    $('.leaflet-control-zoom-in').html '+'
    $('.leaflet-control-zoom-out').html '-'

    clusters = new L.MarkerClusterGroup(
      iconCreateFunction: clusterIcon
    )

    socket.on 'new status', (status) ->
      id = spaceId status.space
      for location in locations
        if location.id == id
          location['status'] = status.open
          break
        
    addTweetToMap = (tweet) ->
      if tweet.coordinates
        marker = tweetMarker(tweet)
        marker.addTo(map)
        tweets.push marker
      else
        tweets.push null

    for space in locations
      marker = spaceMarker(space)
        .addTo(clusters)
      space['marker'] = marker
      marker['space'] = space

    socket.on 'previous tweet', addTweetToMap
    socket.on 'new tweet', (data) ->
      addTweetToMap(data)
      map.removeLayer tweets[0] if tweets[0]
      tweets.shift()

    delay 1000, () ->
      layer = L.tileLayer $('link[rel=tiles]').attr('href'),
        attributionControl: false
      layer.addTo map
      clusters.addTo map
