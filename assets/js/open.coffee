#= require open_space

window.openSpaces = (socket) ->

  makeId = (name) ->
    name.toLowerCase().replace /[^a-z0-9]+/g, '-'

  selector = (status) ->
    $ "#open li##{status.clientId}"

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
      .slideUp () -> $(this).remove()

  socket.on 'new status', (status) ->
    status['clientId'] = makeId status.space
    if status.open
      if selector(status).length == 0
        add status
      else
        update status
    else
      remove status
