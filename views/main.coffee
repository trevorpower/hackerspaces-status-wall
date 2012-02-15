jQuery ->
  $.getJSON(
    "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
    (directory) ->
      $.each(directory, (name, url) ->
        $.getJSON(
          url
          (space) ->
            if space.open?
              if space.open
                space['state'] = 'open'
                space['state_icon'] = space.icon.open if space.icon?
              else 
                space['state'] = 'closed'
                space['state_icon'] = space.icon.close if space.icon?
            else
              space['state'] = 'unknown'
              space['state_icon'] = ''
            section = $($('#spacetile').render(space))
              .hide()
              .appendTo('#list')
              .fadeIn()
            $('#loading').remove() 
            section.mousemove((e)->
              $(this).css("background-position-x", -((e.pageX - 130) - section.offset().left) + "px")
              $(this).css("background-position-y", -((e.pageY - 130) - section.offset().top) + "px")
            )
        )
      )
  )
