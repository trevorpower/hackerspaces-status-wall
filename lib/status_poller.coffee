request = require 'request'
statusDocument = require '../lib/space_info'

hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

statuses = {}

module.exports = (concurrency) ->

  listen: (directory, callback) ->

    poll = (space, done) ->
      request space.url, (err, res, body) ->
        if err
          console.log "error for #{space.name}: #{err}"
          done()
        else
          latest = statusDocument body

          current = statuses[space.name]
          if latest == null
            conosle.log "invalid status from #{space.name}"
            conosle.log "ERROR: #{latest.error}"
          else if current? and hasChanged(latest.status, current.status)
            callback(latest)
          else
            console.log "status from #{latest.status.space} unchanged"

          statuses[space.name] = latest
          done()

    queue = require('async').queue(poll, concurrency)
    
    queue_spaces = (directory) ->
      console.log 'queuing directory'
      for name, url of directory
        queue.push {name: name, url: url}

    queue_spaces directory

    queue.empty = () ->
      queue_spaces directory
