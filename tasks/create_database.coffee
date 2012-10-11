database = require('../database/database') require('../database/settings/production')
  
database.connect (err, db) ->
  if err
    console.log err
    process.exit()
  else
    require('../database/create') db, {}, (err) ->
      console.log err if err
      process.exit()
