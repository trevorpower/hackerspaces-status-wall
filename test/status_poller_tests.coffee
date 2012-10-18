statusPoller = require('../lib/status_poller')

exports.canRequest = (test) ->

  states =
    "http://milklabs.ie":
      space: "milklabs"
      status: "closed"
      open: true

  directory =
    milklabs: "http://milklabs.ie"

  request = (url, callback) ->
    setTimeout(
      () -> callback(null, states[url])
      100
    )

  poller = statusPoller 1, request

  events = []

  poller.listen directory, (status) ->
    events.push status

  asserts = () ->
    poller.stop()
    test.equal events.length, 1
    test.done()

  setTimeout asserts, 1000
