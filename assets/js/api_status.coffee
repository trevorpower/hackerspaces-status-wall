#= require space_api_status

window.createLog = (name, url) ->
  $(space_api_status({ name: name, url: url}))
    .appendTo('#loading > ul')
  report = (type, details = '') ->
    list = $("li[id='#{name}']")
      .addClass(type)
      .find('ul')
    $('<li/>').appendTo(list).text(details) if details != ''
  success: (details) -> report 'success', details
  warning: (details) -> report 'warning', details
  error: (details) -> report 'error', details
