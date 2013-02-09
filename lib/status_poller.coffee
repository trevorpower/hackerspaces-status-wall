hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

module.exports = (concurrency, request) ->

  stop: null

  listen: (directory, callback) ->

    statuses = {}

    poll = (space, done) ->
      request space.url, (err, status) ->
        if err
          console.log "error for #{space.id}: #{err}"
          done()
        else
          current = statuses[space.id] || {open: null}

          status['slug'] = space.slug

          if hasChanged(status, current)
            callback(status)

          statuses[space.id] = status

          done()

    queue = require('async').queue(poll, concurrency)
    
    queue_spaces = (directory) ->
      for space in directory
        queue.push
          id: space.id
          url: space.api
          slug: space.slug

    queue_spaces directory

    queue.empty = () ->
      queue_spaces directory

    this.stop = () -> queue.empty = null

    this.current = (callback) ->
      for name, status of statuses
        callback status
    
