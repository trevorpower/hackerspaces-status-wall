#= require vendor/leaflet.js
#= require vendor/leaflet.markercluster.js
#= require map_marker

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

tweets = []
clusters = null

tweetMarker = (tweet) ->
  L.circleMarker tweet.coordinates.coordinates.reverse(),
    weight: 0
    fillColor: '#114169'
    fillOpacity: 1
    radius: 3

sizeIndex = (num) ->
  fibs = [0,1,2,3,4,5,8,13,21,34,55,89,144,233,377,610,987,1597]
  for fib, index in fibs
    return index if num <= fib
    
clusterIcon = (cluster) ->
  markers = cluster.getAllChildMarkers()
  total = markers.length
  opened = markers.filter((s) -> s.space.status == true).length
  closed = markers.filter((s) -> s.space.status == false).length
  L.divIcon
    iconSize: new L.Point(98, 24)
    html: """
          <span class='open size#{sizeIndex opened}'>#{opened}</span>
          <span class='total size#{sizeIndex total}'>#{total}</span>
          <span class='close size#{sizeIndex closed}'>#{closed}</span>
          """
    className: 'cluster'

locationClass =
  unknown: 'location'
  open: 'location open'
  closed: 'location closed'

icon = (space) ->
  L.divIcon
    html: ''
    className: switch space.status
      when true then 'location open'
      when false then 'location closed'
      else 'location'

spaceMarker = (space) ->
  marker = L.marker space.location,
    icon: icon(space)
    
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
      for location in locations
        if location.slug == status.slug
          location['status'] = status.open
          marker = location['marker']
          clusters.removeLayer marker
          marker.setIcon icon(location)
          clusters.addLayer marker
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
        .bindPopup(map_marker(space))
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
