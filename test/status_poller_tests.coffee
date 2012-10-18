directory =
  milklabs: "http://milklabs.ie"

states = {}

request = (url, callback) ->
  setTimeout(
    () -> callback(null, states[url])
    10
  )

poller = null

exports.setUp = (done) ->
  statusPoller = require('../lib/status_poller')
  poller = statusPoller 1, request
  done()

exports.tearDown = (done) ->
  poller.stop()
  done()

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

    setTimeout assertSpaceClosedEvent, 200

  setTimeout assertSpaceOpenEvent, 200

exports.closedEventIsFiredWhenStatusTextChanges = (test) ->

  states["http://milklabs.ie"] =
    space: "milklabs"
    status: "doing stuff"
    open: true

  events = []

  poller.listen directory, (status) ->
    events.push status

  assertInitialStausEvent = () ->
    test.equal events.length, 1
    test.equal events[0].status, "doing stuff"

    states["http://milklabs.ie"] =
      space: "milklabs"
      status: "doing other stuff"
      open: true

    assertSpaceHasNewStatus = () ->
      test.equal events.length, 2
      test.equal events[1].status, "doing other stuff"
      test.done()

    setTimeout assertSpaceHasNewStatus, 200

  setTimeout assertInitialStausEvent, 1000

