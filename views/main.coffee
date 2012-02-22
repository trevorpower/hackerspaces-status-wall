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

getJsonFromApi = (name, url, success) ->
  reportStart name, url
  $.ajax
    url: url
    datatype: 'json'
    cache: false
    success: (result, status, xhr) ->
      success(getResultObject(name, result, xhr))
    error: (xhr, status, error) ->
      reportError name, getAjaxErrorText(xhr, status, error)

getSpaceInfo = (name, url) ->
  getJsonFromApi(
    name,
    url,
    (spaceInfo) ->
      createSpaceTile(spaceInfo)
        .hide()
        .appendTo('#spaces')
        .fadeIn()
        .find('.tile')
        .movingBackground()
  )
          
jQuery ->
  getJsonFromApi(
    'Directory',
    directoryUrl,
    (directory) -> $.each(directory, getSpaceInfo)
  )
