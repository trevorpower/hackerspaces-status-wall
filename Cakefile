fs = require 'fs'
path = require 'path'
wrench = require 'wrench'

generated_static = 'generated_static'

task 'clean', "Delete generated files", () ->
  wrench.rmdirSyncRecursive generated_static

task 'precompile', 'Create static assets', () ->
  fs.mkdirSync generated_static
  fs.mkdirSync path.join(generated_static, 'wall')
  jade = require 'jade'
  content = jade.compile fs.readFileSync('wall/index.jade')
  fs.writeFile path.join(generated_static, 'wall/index.html'), content()
