#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .

window.loadVenues = () ->
  url = "/venues"
  $.ajax
    url: url,
    dataType: 'json',
    type: 'GET'
    success: (data, status, xhr) ->
      $(data).each () ->
        venue = this
        lat_lng = new google.maps.LatLng(venue.lat, venue.lng)
        marker = new google.maps.Marker
          position: lat_lng
          map: window.map
          title: venue.name
          icon: "music.png"
        google.maps.event.addListener marker, 'click', () ->
          lat_lng = marker.getPosition()
          lat = lat_lng.lat()
          lng = lat_lng.lng()

          url = "/concerts"
          $.ajax
            url: url,
            data:
              lat: lat
              lng: lng
            dataType: 'json',
            type: 'GET'
            success: (data, status, xhr) ->
              $("body").addClass("opened")
              $(".concerts").html("").append(data.body)

$(document).ready ->

  window.map = new google.maps.Map(document.getElementById("map"),
    mapTypeId: google.maps.MapTypeId.TERRAIN
    zoom: 14
  )

  window.map.setCenter(new google.maps.LatLng(48.583148, 7.747882000000004))

  google.maps.event.addDomListener window, "resize", () ->
    center = window.map.getCenter()
    google.maps.event.trigger(window.map, "resize")
    window.map.setCenter(center)

  window.loadVenues()
