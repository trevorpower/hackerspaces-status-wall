jQuery ->
  $.getJSON(
    "http://status.mlkl.bz/json"
    (data) ->
      $('#list').html($('#spacetile').render(data))
  )
