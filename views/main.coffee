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

getSpaceInfo = (name, url, tries = 1) ->
  $($('#progress').render({ name: name, url: url}))
    .appendTo('#loading ul') if tries == 1
  $.ajax
    url: url
    datatype: 'json'
    success: (spaceInfo, statusText) ->
      $("li[id='#{name}']").remove()
      createSpaceTile(spaceInfo)
        .hide()
        .appendTo('#spaces')
        .fadeIn()
        .movingBackground()
    error: (jqXHR, textStatus, errorThrown) ->
      details = $("li[id='#{name}']")
        .addClass('error')
        .find('.details')
      switch textStatus
        when "error"
          if jqXHR.status == 0
            details.text "#{errorThrown} #{JSON.stringify(jqXHR)} (Tries #{tries})"
            getSpaceInfo name, url, tries + 1 if tries < 3
          else
            details.text "#{jqXHR.status}:#{errorThrown}"
        when "timeout"
          details.text "The request timed out."
        when "parsererror" 
          details.text "#{errorThrown}\n#{jqXHR.responseText}"
          
jQuery ->
  $.getJSON(directorySource, (directory) ->
    $.each(directory, getSpaceInfo)
  )
