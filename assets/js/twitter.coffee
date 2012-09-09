#= require_tree vendor
#= require tweet

curateList = () ->
  $('#tweets ul li').eq(-3)
    .fadeTo(3000, 0.5)
  $('#tweets ul li').eq(-4)
    .fadeTo(3000, 0.3)
  $('#tweets ul li').eq(-5)
    .fadeOut(3000, () -> $(this).remove())

socket = io.connect '/'

socket.on 'new tweet', (data) ->
  $(tweet(data))
    .hide()
    .appendTo('#tweets ul')
    .slideDown()
  curateList()

socket.on 'previous tweet', (data) ->
  $(tweet(data))
    .hide()
    .prependTo('#tweets ul')
    .slideDown()
  curateList()

jQuery ->
  socket.emit 'previous tweets', 4
