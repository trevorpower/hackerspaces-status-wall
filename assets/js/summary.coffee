#= require vendor/guage.min.js

gauge = null

window.summary = (socket) ->

  jQuery ->
    gauge = new Gauge($('#summary canvas').get(0)).setOptions
      angle: 0.05
      pointer:
        color: '#A36816'
      colorStart: '#FDD297'
      colorStop: '#FDD297'
      strokeColor: '#FDC372'
      generateGradient: false
    gauge.setTextField $('#summaryGauge .value').get(0)

  directory = {}

  openCount = () ->
    count = 0
    for name, space of directory
      count += 1 if space.open
    count

  socket.on 'new status', (status) ->
    directory[status.space] = status
    gauge.set openCount() if gauge
