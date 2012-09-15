directoryUrl = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
database = require '../database'
createDirectory = require '../lib/directory'

console.log 'requesting directory'

complete = (status) ->
  console.log status
  process.exit()

require('request') directoryUrl, (err, res, body) ->
  if err
    complete err
  else
    console.log 'reply recieved'
    database.connect 'hackerspaces-me', 'directories', (err, db, directories) ->
      if err
        complete err
      else
        directories.insert createDirectory(JSON.parse(body)), (err) ->
          if err
            complete err
          else
            complete 'directory stored'
