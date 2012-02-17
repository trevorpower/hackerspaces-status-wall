directorySource = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

jQuery.fn.movingBackground = ->
  this.mousemove (e)->
    offset = $(this).offset()
    $(this)
      .css("background-position-x", "#{offset.left - e.pageX}px")
      .css("background-position-y", "#{offset.top - e.pageY}px")
    
createSpaceTile = (info) ->
  if info.open
    info['state'] = 'open'
    info['state_icon'] = info.icon.open if info.icon?
  else 
    info['state'] = 'closed'
    info['state_icon'] = info.icon.close if info.icon?
  $($('#spacetile').render(info))

jQuery ->
  $.getJSON(directorySource, (directory) ->
      $.each(directory, (name, url) ->
        $($('#progress').render({ name: name, url: url}))
          .appendTo('#loading ul')
        $.ajax
          url: url
          datatype: 'json'
          success: (spaceInfo, statusText) ->
            $("li[id='#{name}']").remove()
            #alert(spaceInfo)
            createSpaceTile(spaceInfo)
              .hide()
              .appendTo('#spaces')
              .fadeIn()
              .movingBackground()
          error: (jqXHR, textStatus, errorThrown) ->
            $("li[id='#{name}']").addClass('error')
      )
  )
