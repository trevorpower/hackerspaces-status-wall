#= require vendor/guage.min.js
#= require gaugeTemplate

repeat = (time, func) -> setInterval func, time

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
    gauge.children('.min').html '0'
    gauge.children('.max').html "#{total}"

    openGauge = new Gauge(gauge.children('canvas').get(0))
      .setOptions gaugeOptions
    openGauge.setTextField gauge.children('.value').get(0)
    openGauge.maxValue = total

  setupTweetGauge = () ->
    gauge = $ gaugeTemplate(id: 'tweetRate', title: 'Tweets per Hour')
    gauge.appendTo '#summary'
    gauge.children('.min').html '0'
    gauge.children('.max').html '100'

    tweetGauge = new Gauge(gauge.children('canvas').get(0))
      .setOptions gaugeOptions
    tweetGauge.setTextField gauge.children('.value').get(0)
    tweetGauge.maxValue = 100
    repeat 4000, () -> updateTweetsGauge()

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
    return 0 unless tweets.length
    earliest = new Date(tweets[0].created_at)
      .getTime()
    span = new Date().getTime() - earliest
    rate = tweets.length / span
    Math.round(rate * 1000 * 60 * 60)

  updateTweetsGauge = () ->
    tweetGauge.set tweetRate() if tweetGauge

  socket.on 'previous tweet', (data) ->
    tweets.push data
    updateTweetsGauge()

  socket.on 'new tweet', (data) ->
    tweets.shift()
    tweets.push data
    updateTweetsGauge()

