#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .

$(document).ready ->

  map = new google.maps.Map(document.getElementById("map"),
    mapTypeId: google.maps.MapTypeId.TERRAIN
    zoom: 14
  )

  map.setCenter(new google.maps.LatLng(48.583148, 7.747882000000004))

  google.maps.event.addDomListener window, "resize", () ->
    center = map.getCenter()
    google.maps.event.trigger(map, "resize")
    map.setCenter(center)
