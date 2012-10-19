directory = milklabs: "http://milklabs.ie"
states = null
poller = null

exports.setUp = (done) ->

  request = (url, callback) ->
    setTimeout(
      () ->
        callback null,
          space: states[url].space
          status: states[url].status
          open: states[url].open
      10
    )

  states =
    "http://milklabs.ie":
      space: "milklabs"
      status: "closed"
      open: true

  poller = require('../lib/status_poller')(1, request)
  done()

exports.tearDown = (done) ->
  poller.stop()
  setTimeout done, 100

exports.closedEventIsFiredWhenStatusChangesToClosed = (test) ->

  states["http://milklabs.ie"].open = true

  events = []
  poller.listen directory, (status) ->
    events.push status

  assertSpaceOpenEvent = () ->
    test.equal events.length, 1
    test.equal events[0].open, true

    states["http://milklabs.ie"].open = false

    assertSpaceClosedEvent = () ->
      test.equal events.length, 2
      test.equal events[1].open, false

      test.done()

    setTimeout assertSpaceClosedEvent, 200

  setTimeout assertSpaceOpenEvent, 200

exports.closedEventIsFiredWhenStatusTextChanges = (test) ->

  states["http://milklabs.ie"].status = "doing stuff"

  events = []

  poller.listen directory, (status) ->
    events.push status

  assertInitialStausEvent = () ->
    test.equal events.length, 1
    test.equal events[0].status, "doing stuff"

    states["http://milklabs.ie"].status = "doing other stuff"

    assertSpaceHasNewStatus = () ->
      test.equal events.length, 2
      test.equal events[1].status, "doing other stuff"
      test.done()

    setTimeout assertSpaceHasNewStatus, 200

  setTimeout assertInitialStausEvent, 200
