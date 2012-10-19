#= require open_space

window.openSpaces = (socket) ->

  socket.on 'new status', (status) ->
    if status.open
      $(open_space(status))
        .hide()
        .appendTo('#open ul')
        .slideDown()
    else
      $("#open li##{status.space}").remove()

  jQuery -> socket.emit 'replay statuses'

