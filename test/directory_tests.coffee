createDirectory = require '../lib/directory'

exports.directoryContainsDate = (test) ->

  result = createDirectory "{}"

  test.ok result['date']
  test.done()

exports.directoryContainsSpaces = (test) ->

  result = createDirectory "{}"

  test.ok result['spaces']
  test.done()
