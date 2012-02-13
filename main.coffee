jQuery ->
  $.getJSON(
    "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
    (directory) ->
      $.each(directory, (name, url) ->
        $.getJSON(
          url
          (space, statusText) ->
            $('#list').append($('#spacetile').render(space))
            $('#loading').remove() 
        )
      )
  )
