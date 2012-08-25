createStatusFromResponse = require '../lib/space_info'

exports.spaceInfoContainsDate = (test) ->

  result = createStatusFromResponse
    body: "{}"

  test.ok result['date']
  test.done()

exports.spaceInfoContainsStatus = (test) ->

  result = createStatusFromResponse
    body: '{"status": "open"}'

  test.deepEqual result.status, {status: "open"}
  test.done()
