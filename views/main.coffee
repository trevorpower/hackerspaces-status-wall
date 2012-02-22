directoryUrl = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

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

getResultObject = (name, ajaxResult, xhr) ->
  return ajaxResult unless $.type(ajaxResult) == "string"
  reportWarning name, "Content-Type: #{xhr.getResponseHeader('Content-Type')}"
  $.parseJSON(ajaxResult)

reportStart = (name, url) ->
  $($('#progress').render({ name: name, url: url}))
    .appendTo('#loading ul')

reportWarning = (name, error) ->
  details = $("li[id='#{name}']")
    .addClass('warning')
    .find('.details')
    .text(error)
    
reportError = (name, error) ->
  details = $("li[id='#{name}']")
    .addClass('error')
    .find('.details')
    .text(error)

getSpaceInfo = (name, url) ->
  reportStart name, url
  $.ajax
    url: url
    datatype: 'json'
    cache: false
    success: (result, statusText, xhr) ->
      spaceInfo = getResultObject name, result, xhr
      createSpaceTile(spaceInfo)
        .hide()
        .appendTo('#spaces')
        .fadeIn()
        .find('.tile')
        .movingBackground()
    error: (jqXHR, textStatus, errorThrown) ->
      reportError name, getAjaxErrorText(jqXHR, textStatus, errorThrown)
          
jQuery ->
  reportStart 'Directory', directoryUrl
  $.ajax
    url: directoryUrl
    datatype: 'json'
    success: (result, status, xhr) ->
      directory = getResultObject 'Directory', result, xhr
      $.each(directory, getSpaceInfo)
    error: (xhr, status, error) ->
      reportError 'Directory', getAjaxErrorText(xhr, status, error) 
