createStatusFromResponse = require '../lib/space_info'

exports.spaceInfoContainsDate = (test) ->

  result = createStatusFromResponse "{}"

  test.ok result['date']
  test.done()

exports.spaceInfoContainsStatus = (test) ->

  result = createStatusFromResponse '{"status": "open"}'

  test.deepEqual result.status, {status: "open"}
  test.done()
