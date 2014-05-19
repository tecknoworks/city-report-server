reparaMap = ->
  mapMain = $(".map")
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
  infoWindowContent = $("<div>")

  title = $("<h3>").addClass('text-center').html(issue["name"])
  infoWindowContent.append title

  if issue.hasOwnProperty("images")
    if issue["images"].length > 0
      img = $("<img>").attr("src", issue["images"][0]["url"]).addClass("small").addClass('center-block img-responsive')
      infoWindowContent.append img

  lat = $("<p>").addClass('text-center').html(issue["lat"] + " - " + issue["lon"])
  infoWindowContent.append lat

  if issue.hasOwnProperty("address")
    address = $("<p>").addClass('text-center').html(issue["address"])
    infoWindowContent.append address

  infoWindowContent.html()

initMap = ->
  map = reparaMap()
  google.maps.event.addListener map, "click", (data) ->
    console.log data.latLng
    return

  q = $('.map').data('q')
  console.log(q)
  $.get "/issues?q=" + q, (data) ->
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
  initMap() if $(".map").length

  $('.table tbody tr').click () ->
    issue_json = $(this).data('json')
    $('#issueTitle').val(issue_json['name'])
    $('#issueAddress').val(issue_json['address'])
    $('#issueLat').val(issue_json['lat'])
    $('#issueLon').val(issue_json['lon'])

    $('#myModal').modal()
  return
