directorySource = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

jQuery.fn.movingBackground = ->
  this.mousemove (e)->
    offset = $(this).offset()
    $(this)
      .css("background-position-x", "#{offset.left - e.pageX}px")
      .css("background-position-y", "#{offset.top - e.pageY}px")
    
createSpaceTile = (info) ->
  if info['open']
    info['state'] = 'open'
    info['state_icon'] = info.icon.open if info.icon?
  else 
    info['state'] = 'closed'
    info['state_icon'] = info.icon.closed if info.icon?
  $($('#spacetile').render(info))

getAjaxErrorText = (xhr, status, error) ->
  switch status
    when "error"
      if xhr.status == 0
        "#{JSON.stringify(xhr)}"
      else
        "#{xhr.status}:#{error}"
    when "timeout"
      "The request timed out."
    when "parsererror" 
      "#{error}\n--\n#{xhr.responseText}"

getSpaceInfo = (name, url) ->
  $($('#progress').render({ name: name, url: url}))
    .appendTo('#loading ul')
  $.ajax
    url: url
    datatype: 'json'
    cache: false
    success: (spaceInfo, statusText, xhr) ->
      if $.type(spaceInfo) == "string"
        spaceInfo = $.parseJSON(spaceInfo)
        details = $("li[id='#{name}']")
          .addClass('warning')
          .find('.details')
          .text("Content-Type: #{xhr.getResponseHeader('Content-Type')}")
      createSpaceTile(spaceInfo)
        .hide()
        .appendTo('#spaces')
        .fadeIn()
        .find('.tile')
        .movingBackground()
    error: (jqXHR, textStatus, errorThrown) ->
      details = $("li[id='#{name}']")
        .addClass('error')
        .find('.details')
        .text(getAjaxErrorText(jqXHR, textStatus, errorThrown))
          
jQuery ->
  $.getJSON(directorySource, (directory) ->
    $.each(directory, getSpaceInfo)
  )
