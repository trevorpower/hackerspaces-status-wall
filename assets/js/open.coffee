#= require open_space

window.openSpaces = (socket) ->

  socket.on 'new status', (status) ->
    alert 'new status'
    $(open_space(status))
      .hide()
      .appendTo('#open ul')
      .slideDown()
