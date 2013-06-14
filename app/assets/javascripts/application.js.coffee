#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .

$(document).ready ->

  map = new google.maps.Map(document.getElementById("map"),
    mapTypeId: google.maps.MapTypeId.TERRAIN
    zoom: 14
  )

  center = new google.maps.LatLng(48.583148, 7.747882000000004)
  map.setCenter center
