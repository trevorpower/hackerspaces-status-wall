directoryUrl = "http://chasmcity.sonologic.nl/spacestatusdirectory.php"

jQuery.fn.movingBackground = ->
  this.mousemove (e)->
    offset = $(this).offset()
    $(this)
      .css("background-position-x", "#{offset.left - e.pageX}px")
      .css("background-position-y", "#{offset.top - e.pageY}px")
    
reportStart = (name, url) ->
  $($('#progress').render({ name: name, url: url}))
    .appendTo('#loading ul')

report = (name, type, details = '') ->
  details = $("li[id='#{name}']")
    .addClass(type)
    .find('.details')
    .text(details)

reportSuccess = (name, error) ->
  report name, 'success'
    
reportWarning = (name, error) ->
  report name, 'warning', error
    
reportError = (name, error) ->
  report name, 'error', error

createSpaceTile = (info) ->
  if info['open']
    info['state'] = 'open'
    info['state_icon'] = info.icon.open if info.icon?
  else 
    info['state'] = 'closed'
    info['state_icon'] = info.icon.closed if info.icon?
  tile = $($('#spacetile').render(info))
  tile.find('ul').hide()
  tile.hover( -> $(this).find('ul').fadeToggle('fast', 'linear') )
  tile.find('.tile').movingBackground()
  tile

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

getJsonFromProxy = (name, url, success) ->
  $.ajax
    type: 'POST'
    url: "/proxy"
    data: url
    processData: false
    datatype: 'json'
    success: (result, status, xhr) -> 
      return reportError name, "via proxy: #{result['error']}" if result['error']
      reportWarning name, 'via proxy'
      success(getResultObject(name, result, xhr))
    error: (xhr, status, error) ->
      reportError name, "via proxy: #{getAjaxErrorText xhr, status, error}"

getJsonFromApi = (name, url, success) ->
  reportStart name, url
  $.ajax
    url: url
    datatype: 'json'
    cache: false
    success: (result, status, xhr) ->
      reportSuccess name
      success(getResultObject(name, result, xhr))
    error: (xhr, status, error) ->
      getJsonFromProxy name, url, success
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
  )
          
jQuery ->
  getJsonFromApi(
    'Directory',
    directoryUrl,
    (directory) -> $.each(directory, getSpaceInfo)
  )
