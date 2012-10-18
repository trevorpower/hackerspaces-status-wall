statusPoller = require('../lib/status_poller')

directory =
  milklabs: "http://milklabs.ie"

states = {}

request = (url, callback) ->
  setTimeout(
    () -> callback(null, states[url])
    10
  )

poller = statusPoller 1, request

exports.oneEventIsFiredWhenPollingStarts = (test) ->

  states["http://milklabs.ie"] =
    space: "milklabs"
    status: "closed"
    open: true

  events = []

  poller.listen directory, (status) ->
    events.push status

  asserts = () ->
    poller.stop()
    test.equal events.length, 1
    test.done()

  setTimeout asserts, 100
