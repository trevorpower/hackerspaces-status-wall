module.exports = (body) ->
  createStatusDocument = (status, error) ->
    date: new Date()
    status: status
    error: error
  try
    status = JSON.parse body
    createStatusDocument status, null
  catch e
    createStatusDocument null, e
