window.summary = (socket) ->

  directory = {}

  openSummary = () ->
    open = 0
    for name, space of directory
      open += 1 if space.open
    if open == 1
      "1 space is now open"
    else
      "#{open} spaces are now open"

  socket.on 'new status', (status) ->
    directory[status.space] = status
    $('#openTotal').html(openSummary())
  
