request = require 'request'

module.exports = (url, callback) ->
  request url, (err, res, body) ->
    if err
      callback err
    else
      try
        callback null, JSON.parse body
      catch e
        callback e
