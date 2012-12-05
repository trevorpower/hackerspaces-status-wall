#= require vendor/jquery-1.7.1.min.js
#= require vendor/runtime.min.js
#= require vendor/socket.io.min.js
#= require vendor/modernizr.js
#= require open
#= require map
#= require tweets
#= require summary

socket = io.connect '/'

openSpaces socket
tweets socket
map socket
summary socket

jQuery ->
  socket.emit 'replay statuses'
  socket.emit 'previous tweets', 4
