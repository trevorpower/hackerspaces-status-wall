require('../database').connect 'hackerspaces-me', (err, db) ->
  if err
    console.log err
    process.exit()
  else
    require('../database/create') db, {}, (err) ->
      console.log err if err
      process.exit()
