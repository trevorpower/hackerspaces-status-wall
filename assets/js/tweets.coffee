#= require tweet
#= require vendor/jquery.timeago

window.tweets = (socket) ->

  curateList = () ->
    $('#tweets ul li').eq(2)
      .fadeTo(3000, 0.5)
    $('#tweets ul li').eq(3)
      .fadeTo(3000, 0.3)
    $('#tweets ul li').eq(4)
      .fadeOut(3000, () -> $(this).remove())

  socket.on 'new tweet', (data) ->
    $(tweet(data))
      .hide()
      .prependTo('#tweets ul')
      .slideDown()
      .find('time')
      .timeago()
    curateList()

  socket.on 'previous tweet', (data) ->
    $(tweet(data))
      .hide()
      .appendTo('#tweets ul')
      .slideDown()
      .find('time')
      .timeago()
    curateList()
