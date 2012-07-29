#= require vendor/jquery-1.7.1.min
socket = io.connect 'http://0.0.0.0:5000'
socket.on 'test', (data) ->
  alert data
