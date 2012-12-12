hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

module.exports = (concurrency, request) ->

  stop: null

  listen: (directory, callback) ->

    statuses = {}

    poll = (space, done) ->
      request space.url, (err, status) ->
        if err
          console.log "error for #{space.name}: #{err}"
          done()
        else
          current = statuses[space.name] || {open: null}

          if hasChanged(status, current)
            callback(status)

          statuses[space.name] = status

          done()

    queue = require('async').queue(poll, concurrency)
    
    queue_spaces = (directory) ->
      for space in directory
        queue.push {name: space.name, url: space.api}

    queue_spaces directory

    queue.empty = () ->
      queue_spaces directory

    this.stop = () -> queue.empty = null

    this.current = (callback) ->
      for name, status of statuses
        callback status
    
