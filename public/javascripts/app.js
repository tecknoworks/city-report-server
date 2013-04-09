$(document).ready(function() {
  var mapDiv = $('#map-main')[0];
  var mapCenter = new google.maps.LatLng(46.768322, 23.595002);
  var mapOptions = {
    zoom: 14,
    center: mapCenter,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  }
  var map = new google.maps.Map(mapDiv, mapOptions);

  google.maps.event.addListener(map, 'click', function(data) {
    console.log(data.latLng);
  });

  $.get('/issues', function(data) {
    for (var pin in data) {
      var issue = data[pin];
      var marker = new google.maps.Marker({
        map: map,
        position: new google.maps.LatLng(issue['lat'], issue['lon']),
        title: issue['title'],
        icon: '/images/marker.png'
      });

      google.maps.event.addListener(marker, 'click', (function(marker, issue) {
        var infoWindowContent = $("<div>");
        var opened = false;

        var title = $("<h3>").html(issue['title']);
        infoWindowContent.append(title);

        var lat = $("<p>").html("Latitude: " + issue['lat']);
        infoWindowContent.append(lat);
        var lon = $("<p>").html("Longitude: " + issue['lon']);
        infoWindowContent.append(lon);

        if (issue.hasOwnProperty('images')) {
          if (issue['images'].length > 0) {
            var img = $("<img>").attr('src', issue['images'][0]).addClass('small');
            infoWindowContent.append(img);
          }
        }

        var infoWindow = new google.maps.InfoWindow({
          content: infoWindowContent.html()
        });

        return function() {
          if (infoWindow.getMap()!=null) {
            infoWindow.close();
          } else {
            infoWindow.open(map, marker);
          }
        }
      })(marker, issue));
    }
  });
});
