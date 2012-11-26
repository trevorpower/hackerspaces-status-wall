#= require vendor/guage.min.js

gauge = null


window.summary = (socket) ->

  jQuery ->
    gauge = new Gauge($('#summary canvas').get(0)).setOptions
      angle: 0.05
      pointer:
        color: '#A36816'
      colorStart: '#FDC372'
      colorStop: '#FDC372'
      strokeColor: '#FDD297'
      generateGradient: false
    gauge.maxValue = 45
    gauge.setTextField $('#gaugeText').get(0)

  directory = {}

  openCount = () ->
    count = 0
    for name, space of directory
      count += 1 if space.open
    count

  socket.on 'new status', (status) ->
    directory[status.space] = status
    open = openCount()
    gauge.set open if gauge
  
