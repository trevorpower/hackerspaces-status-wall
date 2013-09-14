#= require vendor/jquery-1.7.1.min.js
#= require vendor/knockout-2.3.0.js

LogModel = () ->
  events: ko.observableArray([])

$ ->
  model = new LogModel()

  ko.applyBindings model

  $.ajax('log.json')
    .done (data) ->
      $.each data, (i, e) ->
        model.events.push e
    .fail () ->
      alert "fail"


