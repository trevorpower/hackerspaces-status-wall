#= require_tree vendor
#= require tweets
#= require spaces

socket = io.connect '/'

tweets socket
spaces()
