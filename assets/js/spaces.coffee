#= require api_status
#= require space_tile

window.spaces = () ->
  jQuery.fn.movingBackground = ->
    this.mousemove (e)->
      offset = $(this).offset()
      $(this).css
        "background-position": "#{offset.left - e.pageX}px #{offset.top - e.pageY}px"
      
  formatProxyError = (error, headers, body) ->
    """
    from proxy: #{error}
    --HEADERS--
    #{headers}
    --BODY--
    #{body}
    """

  normalizeSpaceInfo = (info) ->
    if info['open']
      info['state'] = 'open'
      info['state_icon'] = info.icon.open if info.icon?
    else
      info['state'] = 'closed'
      info['state_icon'] = info.icon.closed if info.icon?
      
  createSpaceTile = (log, info) ->
    normalizeSpaceInfo info
    tile = $(space_tile(info))
    tile.find('ul').hide()
    tile.hover( -> $(this).find('ul').fadeToggle('fast', 'linear') )
    tile.find('.tile').movingBackground()
    tile.find('img').error ->
      src = $(this).attr 'src'
      log.warning "icon failed to load: #{src}"
      if src.substring(0, 8) == 'https://'
        src = src.replace('https://', 'http://')
        log.warning "trying #{src}"
        $(this).attr 'src', src
    tile

  ajaxErrorText = (xhr, status, error) ->
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

  reportContentType = (log, contentType) ->
    unless contentType?
      log.warning "Content-Type is unavailable"
    else if contentType.toLowerCase().indexOf('application/json') == -1
      log.warning "Content-Type: #{contentType}"

  reportAllowOrigin = (log, allowOrigin) ->
    if allowOrigin?
      if allowOrigin.toLowerCase().indexOf('*') == -1
        log.warning "Access-Control-Allow-Origin: #{allowOrigin}" 
    else
      log.warning 'Access-Control-Allow-Origin not set'

  getResultObject = (log, ajaxResult, xhr) ->
    return ajaxResult unless $.type(ajaxResult) == "string"
    reportContentType log, xhr.getResponseHeader('Content-Type')
    $.parseJSON(ajaxResult)

  getJsonFromProxy = (log, url, success) ->
    $.ajax
      type: 'POST'
      url: "/proxy"
      data: "url=#{url}"
      processData: true
      datatype: 'jsonp'
      success: (result, status, xhr) -> 
        log.warning 'resort to proxy'
        resultObject = getResultObject(log, result, xhr)
        if resultObject.error?
          log.error formatProxyError(
            resultObject.error,
            JSON.stringify resultObject.headers
            resultObject.body
          )
          return
        reportContentType log, resultObject.headers['content-type']
        reportAllowOrigin log, resultObject.headers['access-control-allow-origin']
        success resultObject.body
      error: (xhr, status, error) ->
        log.error "via proxy: #{ajaxErrorText xhr, status, error}"

  getJsonFromApi = (log, url, success) ->
    $.ajax
      url: url
      datatype: 'json'
      cache: false
      success: (result, status, xhr) ->
        log.success()
        success(getResultObject(log, result, xhr))
      error: (xhr, status, error) ->
        log.error "client ajax: #{ajaxErrorText(xhr, status, error)}"
        getJsonFromProxy log, url, success

  getSpaceInfo = (name, url) ->
    log = createLog(name, url)
    getJsonFromApi(
      log,
      url,
      (spaceInfo) ->
        createSpaceTile(log, spaceInfo)
          .hide()
          .appendTo('#spaces > ul')
          .fadeIn()
    )
            
  jQuery -> $.each(directory, getSpaceInfo)
