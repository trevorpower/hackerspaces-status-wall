#= require_tree vendor
#= require tweet

socket = io.connect 'http://0.0.0.0:5000'

socket.on 'message', (data) ->
  $(tweet(data))
    .hide()
    .appendTo('#tweets ul')
    .slideDown()
  $('#tweets ul li').eq(-3)
    .fadeTo(3000, 0.5)
  $('#tweets ul li').eq(-4)
    .fadeTo(3000, 0.3)
  $('#tweets ul li').eq(-5)
    .fadeOut(3000, () -> $(this).remove())
