directoryUrl = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

console.log 'requesting directory'

require('request') directoryUrl, (err, res, body) ->
  if err
    console.log err
  else
    console.log 'reply recieved'
    require('./directory').store JSON.parse(body), (err) ->
      if err
        console.log err
      else
        console.log 'directory stored'
      process.exit()
