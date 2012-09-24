request = require 'request'

module.exports = (req, res) ->
  request req.body.url, (error, apiResponse, apiBody) ->
    if error?
      res.send error if error?
    else
      try
        res.send
          "headers": apiResponse.headers
          "body": JSON.parse apiBody
      catch ex
        res.send
          "headers": apiResponse.headers
          "body": apiBody
          "error": ex.message
