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

  google.maps.event.addListener(map, "click", function (e) {
    console.log(e);
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
        return function() {

          var infowindow = new google.maps.InfoWindow({
            content: "<div>" + issue['title'] + "</div>"
          });
          infowindow.open(map, marker);
        }
      })(marker, issue));
    }
  });
});
