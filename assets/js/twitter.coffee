#= require vendor/jquery-1.7.1.min

socket = io.connect 'http://0.0.0.0:5000'

socket.on 'message', (data) ->
  $("<li>#{data.text}</li>")
    .hide()
    .prependTo('#tweets')
    .slideDown()
  $('#tweets li:eq(3)')
    .fadeTo(3000, 0.5)
  $('#tweets li:eq(4)')
    .fadeTo(3000, 0.3)
  $('#tweets li:gt(4)')
    .fadeOut(3000, (li) -> li.remove())
