module.exports = (response) ->
  date: new Date()
  status: JSON.parse response.body
