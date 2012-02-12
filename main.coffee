jQuery ->
  $.getJSON(
    "http://status.mlkl.bz/json"
    (data) ->
      $('#list').text(data.space)
  )
