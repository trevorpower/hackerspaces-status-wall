#= require vendor/jquery-1.7.1.min.js

LogModel = () ->
  events: ko.observableArray([])

$ ->
  model = new LogModel()

  $.ajax('log.json')
    .done (data) ->
      $.each data, (i, e) ->
        model.events.push e

  ko.applyBindings model
