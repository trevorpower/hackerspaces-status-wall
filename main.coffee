jQuery ->
  $.getJSON(
    "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
    (data, status) -> alert(status)
  )

