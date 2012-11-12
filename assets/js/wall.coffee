#= require vendor/jquery-1.7.1.min.js
#= require vendor/runtime.min.js
#= require vendor/socket.io.min.js
#= require open
#= require map
#= require tweets

socket = io.connect '/'

openSpaces socket
tweets socket
