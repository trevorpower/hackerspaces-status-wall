directorySource = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

$ = jQuery

$.fn.movingBackground = ->
  this.mousemove (e)->
    $(this).css("background-position-x", "#{$(this).offset().left - e.pageX}px")
    $(this).css("background-position-y", "#{$(this).offset().top - e.pageY}px")
    
createSpaceTile = (info) ->
  if info.open?
    if info.open
      info['state'] = 'open'
      info['state_icon'] = info.icon.open if info.icon?
    else 
      info['state'] = 'closed'
      info['state_icon'] = info.icon.close if info.icon?
  else
    info['state'] = 'unknown'
    info['state_icon'] = ''
  $($('#spacetile').render(info))

jQuery ->
  $.getJSON(directorySource, (directory) ->
      $.each(directory, (name, url) ->
        $($('#progress').render({ name: name, url: url}))
          .appendTo('#loading ul')
        $.getJSON(url, (spaceInfo, statusText) ->
          $("li[id='#{name}']").remove()
          createSpaceTile(spaceInfo)
            .hide()
            .appendTo('#spaces')
            .fadeIn()
            .movingBackground()
        )
      )
  )
