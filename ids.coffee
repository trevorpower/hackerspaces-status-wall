request = require 'request'
twitterApiUrl = "http://api.twitter.com/1/"

console.log 'getting latest directory'
require('./directory').latest (latest) ->
  console.log "directory found for #{latest.date}"
  for name, url of latest.spaces
    console.log "requesting status for #{name}"
    request url, (error, response, body) ->
      try
        space = JSON.parse body
        if space.contact?
          if (space.contact.twitter?)
            screen_name = space.contact.twitter.substring(1)
            request "#{twitterApiUrl}users/show.json?screen_name=#{screen_name}", (error, response, body) ->
              if response.statusCode == 200
                console.log JSON.parse(body).id
