request = require 'request'

directoryUrl = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
twitterApiUrl = "http://api.twitter.com/1/"

request directoryUrl, (error, response, body) ->
  directory = JSON.parse body
  for name, url of directory
    request url, (error, response, body) ->
      try
        space = JSON.parse body
        if space.contact?
          if (space.contact.twitter?)
            screen_name = space.contact.twitter.substring(1)
            request "#{twitterApiUrl}users/show.json?screen_name=#{screen_name}", (error, response, body) ->
              if response.statusCode == 200
                console.log JSON.parse(body).id
