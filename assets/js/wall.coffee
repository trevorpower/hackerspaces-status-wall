#= require vendor/jquery-1.7.1.min.js
#= require vendor/runtime.min.js
#= require vendor/socket.io.min.js
#= require vendor/modernizr.js
#= require open
#= require map
#= require tweets
#= require dashboard

socket = io.connect '/'

openSpaces socket
tweets socket
map socket
dashboard socket

$ ->
  socket.emit 'replay statuses'
  socket.emit 'previous tweets', 4
