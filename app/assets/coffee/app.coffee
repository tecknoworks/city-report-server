initMap = ->
  mapMain = $("#map-main")
  mapDiv = mapMain[0]
  mapCenter = new google.maps.LatLng(mapMain.data('lat'), mapMain.data('lon'))

  mapOptions =
    zoom: 14
    center: mapCenter
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scrollwheel: true
    disableDefaultUI: true

  new google.maps.Map(mapDiv, mapOptions)

getMarkerIcon = (issue) ->
  return "/images/marker.png"

issueToPopup = (issue) ->
  console.log issue
  infoWindowContent = $("<div>")

  title = $("<h3>").html(issue["name"])
  infoWindowContent.append title

  if issue.hasOwnProperty("images")
    if issue["images"].length > 0
      img = $("<img>").attr("src", issue["images"][0]["url"]).addClass("small")
      infoWindowContent.append img
  lat = $("<p>").html(issue["lat"] + " - " + issue["lon"])
  infoWindowContent.append lat

  if issue.hasOwnProperty("address")
    address = $("<p>").html(issue["address"])
    infoWindowContent.append address

  if issue.hasOwnProperty("description")
    description = $("<p>").html(issue["description"])
    infoWindowContent.append description

  infoWindowContent.html()

showMapOnIndexPage = ->
  map = initMap()
  google.maps.event.addListener map, "click", (data) ->
    console.log data.latLng
    return

  $.get "/issues", (data) ->
    for pin of data["body"]
      issue = data["body"][pin]
      marker = new google.maps.Marker(
        map: map
        position: new google.maps.LatLng(issue["lat"], issue["lon"])
        title: issue["name"]
        icon: getMarkerIcon(issue)
      )
      google.maps.event.addListener marker, "click", ((marker, issue) ->
        opened = false
        infoWindow = new google.maps.InfoWindow(content: issueToPopup(issue))
        ->
          if infoWindow.getMap()?
            infoWindow.close()
          else
            infoWindow.open map, marker
          return
      )(marker, issue)
    return

  return

$(document).ready ->
  showMapOnIndexPage()  if $("#map-main").length
  return

