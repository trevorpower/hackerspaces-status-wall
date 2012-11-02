nock = require 'nock'
              
statusRequest = require('../lib/status_request')

exports.canRequest = (test) ->

  status =
    space: "milklabs"
    status: "closed"
    open: true

  milklabs = nock('http://mock.mlkl.bz')
              .get('/test').reply(200, status)

  statusRequest 'http://mock.mlkl.bz/test', (err, status) ->
    test.equal status.space, "milklabs"
    test.equal status.open, true
    test.done()
