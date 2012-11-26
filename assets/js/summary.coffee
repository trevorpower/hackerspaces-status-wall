#= require vendor/guage.min.js

gauge = null

window.summary = (socket) ->

  jQuery ->
    gauge = new Gauge($('#summary canvas').get(0)).setOptions
      angle: 0.05
    gauge.maxValue = 45

  directory = {}

  openCount = () ->
    count = 0
    for name, space of directory
      count += 1 if space.open
    count

  openSummary = (open) ->
    if open == 1
      "1 space is now open"
    else
      "#{open} spaces are now open"

  socket.on 'new status', (status) ->
    directory[status.space] = status
    open = openCount()
    $('#openTotal').html(openSummary(open))
    gauge.set open if gauge
  
