directory =
  milklabs: "http://milklabs.ie"
  tog: "http://tog.ie"
states = null
poller = null
events = null
delay = (time, callback) -> setTimeout(callback, time)

exports.setUp = (done) ->

  request = (url, callback) ->
    delay 10, () ->
      callback null,
        space: states[url].space
        status: states[url].status
        open: states[url].open

  states =
    "http://milklabs.ie":
      space: "milklabs"
      status: "closed"
      open: true
    "http://tog.ie":
      space: "TOG"
      status: "closed"
      open: false

  poller = require('../lib/status_poller')(1, request)
  events = []
  done()

exports.tearDown = (done) ->
  poller.stop()
  setTimeout done, 100

exports.closedEventIsFiredWhenStatusChangesToClosed = (test) ->

  states["http://milklabs.ie"].open = true

  poller.listen directory, (status) ->
    events.push status

  delay 200, () ->
    test.equal events.length, 2, "initial events for each space"
    events.length = 0

    states["http://milklabs.ie"].open = false

    delay 200,  () ->
      test.equal events.length, 1
      test.equal events[0].open, false

      test.done()

exports.closedEventIsFiredWhenStatusTextChanges = (test) ->

  states["http://milklabs.ie"].status = "doing stuff"

  poller.listen directory, (status) ->
    events.push status

  delay 200, () ->
    test.equal events.length, 2, "initial events for each space"
    events.length = 0
    states["http://milklabs.ie"].status = "doing other stuff"

    delay 200, () ->
      test.equal events.length, 1
      test.equal events[0].status, "doing other stuff"

      test.done()

exports.canReplayWithCallToAll = (test) ->

  states["http://milklabs.ie"].status = "doing stuff"

  poller.listen directory, (status) ->
    events.push status

  delay 200, () ->
    test.equal events.length, 2, "initial events for each space"
    events.length = 0

    poller.current (status) ->
      events.push status

    delay 200, () ->
      test.equal events.length, 2

      test.done()
