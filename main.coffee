jQuery ->
  $.getJSON(
    "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
    (directory) ->
      $.each(directory, (name, url) ->
        $.getJSON(
          url
          (space) ->
            space['state'] = 'open'
            $($('#spacetile').render(space))
              .hide()
              .appendTo('#list')
              .fadeIn()
            $('#loading').remove() 
        )
      )
  )
