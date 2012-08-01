#= require vendor/jquery-1.7.1.min

socket = io.connect 'http://0.0.0.0:5000'

socket.on 'message', (data) ->
  $("<li>#{data.user.screen_name} - #{data.text}</li>")
    .hide()
    .appendTo('#tweets ul')
    .slideDown()
  $('#tweets ul li').eq(-3)
    .fadeTo(3000, 0.5)
  $('#tweets ul li').eq(-4)
    .fadeTo(3000, 0.3)
  $('#tweets ul li').eq(-5)
    .fadeOut(3000, () -> $(this).remove())
