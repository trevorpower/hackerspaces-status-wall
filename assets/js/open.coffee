#= require open_space

window.openSpaces = (socket) ->

  socket.on 'new status', (status) ->
    $(open_space(status))
      .hide()
      .appendTo('#open ul')
      .slideDown()
