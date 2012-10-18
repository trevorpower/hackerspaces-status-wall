statusDocument = require '../lib/space_info'

hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

statuses = {}

module.exports = (concurrency, request) ->

  stop: null

  listen: (directory, callback) ->

    poll = (space, done) ->
      request space.url, (err, status) ->
        if err
          console.log "error for #{space.name}: #{err}"
          done()
        else
          current = statuses[space.name]

          if current?
            if hasChanged(status, current)
              callback(status)
              statuses[space.name] = status
          else
            statuses[space.name] = {open: null}

          done()

    queue = require('async').queue(poll, concurrency)
    
    queue_spaces = (directory) ->
      for name, url of directory
        queue.push {name: name, url: url}

    queue_spaces directory

    queue.empty = () ->
      queue_spaces directory

    this.stop = () -> queue.empty = null
