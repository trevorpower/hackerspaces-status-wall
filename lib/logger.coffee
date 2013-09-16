module.exports = (collection, activity) ->
  info: (event, details) ->
    collection.insert
      date: new Date()
      activity: activity
      event: event
      details: details
      priority: "info"

  error: (details) ->
    collection.insert
      date: new Date()
      activity: activity
      event: "Error"
      details: details
      priority: "info"

