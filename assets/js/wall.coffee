#= require vendor/jquery-1.7.1.min.js
#= require vendor/runtime.min.js
#= require vendor/socket.io.min.js
#= require tweets
#= require spaces

socket = io.connect '/'

tweets socket
spaces socket
