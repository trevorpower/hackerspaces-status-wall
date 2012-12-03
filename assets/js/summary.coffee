#= require vendor/guage.min.js
#= require gaugeTemplate

gaugeController = null

window.summary = (socket) ->

  jQuery ->
    gauge = $(gaugeTemplate(id: 'openTotal'))
      .appendTo('#summary')

    gaugeController = new Gauge(gauge.children('canvas').get(0))
      .setOptions
        angle: 0.05
        pointer:
          color: '#A36816'
        colorStart: '#FDD297'
        colorStop: '#FDD297'
        strokeColor: '#FDC372'
        generateGradient: false
    gaugeController.setTextField gauge.children('.value').get(0)
    gaugeController.maxValue = total
    gauge.children('.min').html 0
    gauge.children('.max').html total

  directory = {}

  openCount = () ->
    count = 0
    for name, space of directory
      count += 1 if space.open
    count

  socket.on 'new status', (status) ->
    directory[status.space] = status
    gaugeController.set openCount() if gaugeController
