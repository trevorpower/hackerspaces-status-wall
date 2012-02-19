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
    info['state_icon'] = info.icon.closed if info.icon?
  $($('#spacetile').render(info))

getAjaxErrorText = (xhr, status, error, tries) ->
  switch status
    when "error"
      if xhr.status == 0
        "#{JSON.stringify(xhr)} (Tries #{tries})"
      else
        "#{xhr.status}:#{error}"
    when "timeout"
      "The request timed out."
    when "parsererror" 
      "#{error}\n--\n#{xhr.responseText}"

getSpaceInfo = (name, url, tries = 1) ->
  $($('#progress').render({ name: name, url: url}))
    .appendTo('#loading ul') if tries == 1
  $.ajax
    url: url
    datatype: 'json'
    cache: false
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
        .text(getAjaxErrorText(jqXHR, textStatus, errorThrown, tries))
      getSpaceInfo name, url, tries + 1 if tries < 3
          
jQuery ->
  $.getJSON(directorySource, (directory) ->
    $.each(directory, getSpaceInfo)
  )
