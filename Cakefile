fs = require 'fs'
path = require 'path'

generated_static = 'generated_static'

task 'precompile', 'Create static assets', () ->
  fs.mkdir generated_static
  jade = require 'jade'
  content = jade.compile fs.readFileSync('views/wall.jade')
  fs.writeFile path.join(generated_static, 'wall.html'), content()
