#= require vendor/guage.min.js
#= require gaugeTemplate

delay = (time, func) -> setTimeout func, time

gaugeOptions =
  angle: 0.05
  pointer:
    color: '#A36816'
  colorStart: '#FDD297'
  colorStop: '#FDD297'
  strokeColor: '#FDC372'
  generateGradient: false
  
openGauge = null
tweetGauge = null

window.summary = (socket) ->

  setupOpenGauge = () ->
    gauge = $ gaugeTemplate(id: 'openTotal', title: 'Open Spaces')
    gauge.appendTo '#summary'

    openGauge = new Gauge(gauge.children('canvas').get(0))
      .setOptions gaugeOptions
    openGauge.setTextField gauge.children('.value').get(0)
    openGauge.maxValue = total
    gauge.children('.min').html '0'
    gauge.children('.max').html "#{total}"

  setupTweetGauge = () ->
    gauge = $ gaugeTemplate(id: 'tweetRate', title: 'Tweets per Hour')
    gauge.appendTo '#summary'
    gauge.children('.min').html '0'
    gauge.children('.max').html '50'

    tweetGauge = new Gauge(gauge.children('canvas').get(0))
      .setOptions
        angle: 0.05
        pointer:
          color: '#A36816'
        colorStart: '#FDD297'
        colorStop: '#FDD297'
        strokeColor: '#FDC372'
        generateGradient: false
    tweetGauge.setTextField gauge.children('.value').get(0)
    tweetGauge.maxValue = '50'

  jQuery ->
    setupOpenGauge()
    setupTweetGauge()

  directory = {}

  openCount = () ->
    count = 0
    for name, space of directory
      count += 1 if space.open
    count

  socket.on 'new status', (status) ->
    directory[status.space] = status
    openGauge.set openCount() if openGauge

  tweets = []

  tweetRate = () ->
    earliest = new Date(tweets[0].created_at)
      .getTime()
    span = new Date().getTime() - earliest
    rate = tweets.length / span
    rate * 1000 * 60 * 60

  socket.on 'previous tweet', (data) ->
    tweets.push data
    tweetGauge.set tweetRate() if tweetGauge

