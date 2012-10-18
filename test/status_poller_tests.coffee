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

exports.closedEventIsFiredWhenStatusChangesToClosed = (test) ->

  states["http://milklabs.ie"] =
    space: "milklabs"
    status: "closed"
    open: true

  events = []

  poller.listen directory, (status) ->
    events.push status

  assertSpaceOpenEvent = () ->
    test.equal events.length, 1
    test.equal events[0].open, true

    states["http://milklabs.ie"] =
      space: "milklabs"
      status: "closed"
      open: false

    assertSpaceClosedEvent = () ->
      test.equal events.length, 2
      test.equal events[1].open, false

      test.done()
      poller.stop()

    setTimeout assertSpaceClosedEvent, 200

  setTimeout assertSpaceOpenEvent, 200

