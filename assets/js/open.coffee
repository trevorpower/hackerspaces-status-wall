#= require open_space

window.openSpaces = (socket) ->

  selector = (status) ->
    $ "#open li##{status.space.replace(' ','-')}"

  add = (status) ->
    $(open_space(status))
      .hide()
      .prependTo('#open ul')
      .slideDown()

  update = (status) ->
    selector(status)
      .find('.status')
      .slideUp () ->
        $(this).text(status.status)
        $(this).slideDown()

  remove = (status) ->
    selector(status)
      .slideUp () -> this.remove()

  socket.on 'new status', (status) ->
    if status.open
      if selector(status).length == 0
        add status
      else
        update status
    else
      remove status

  jQuery -> socket.emit 'replay statuses'
