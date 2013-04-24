var prepareToggleButton = function () {
  $('#map-toggle').click(function() {
    $('#map-overlay').animate({
      height: 'toggle'
    }, 500, function() {
      $('#map-toggle img').toggleClass('rotate180');
    });
  });
}

var initMap = function () {
  var mapDiv = $('#map-main')[0];
  var mapCenter = new google.maps.LatLng(46.768322, 23.595002);
  var mapOptions = {
    zoom: 14,
    center: mapCenter,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: true,
    disableDefaultUI: true
  }
  return new google.maps.Map(mapDiv, mapOptions);
}

var getMarkerIcon = function (issue) {
  if (issue.categories === undefined) {
    return '/images/icons/altele.png';
  }
  if (issue.categories[0] === undefined) {
    return '/images/icons/altele.png';
  }
  switch (issue.categories[0]) {
    case 'gunoi':
      return '/images/icons/gunoi.png';
    case 'groapa':
      return '/images/icons/groapa.png';
    case 'rutiere':
      return '/images/icons/rutiere.png';
    case 'vandalism':
      return '/images/icons/vandalism.png';
    default:
      return '/images/icons/altele.png';
  }
}

var issueToPopup = function (issue) {

  var infoWindowContent = $("<div>");
  var title = $("<h3>").html(issue['title']);
  infoWindowContent.append(title);

  if (issue.hasOwnProperty('images')) {
    if (issue['images'].length > 0) {
      var img = $("<img>").attr('src', issue['images'][0]).addClass('small');
      infoWindowContent.append(img);
    }
  }

  var lat = $("<p>").html(issue['lat'] + " - " + issue['lon']);
  infoWindowContent.append(lat);

  if (issue.hasOwnProperty('address')) {
    var address = $("<p>").html(issue['address']);
    infoWindowContent.append(address);
  }

  if (issue.hasOwnProperty('description')) {
    var description = $("<p>").html(issue['description']);
    infoWindowContent.append(description);
  }

  return infoWindowContent.html();
}

$(document).ready(function() {
  prepareToggleButton();
  var map = initMap();

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
        icon: getMarkerIcon(issue)
      });

      google.maps.event.addListener(marker, 'click', (function(marker, issue) {
        var opened = false;
        var infoWindow = new google.maps.InfoWindow({
          content: issueToPopup(issue)
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
