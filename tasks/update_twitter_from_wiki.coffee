request = require 'request'

query =
  uri: 'http://hackerspaces.org/wiki/Special:Ask'
  json: true
  qs:
    q: '[[Category:Hackerspace]][[Twitter::+]]'
    po: '?Twitter'
    'p[format]': 'json'
    limit: 5

request query, (err, response, body) ->
  if err
    console.log err
  else
    console.log space for space in body.items


