var loadPinpoints = function() {
  var map = $('#map-main');
  $.get("/issues", function(data) {
    console.log(data);
    // $.each(data["response"]["issues"], function(index, value) {
    //   var location = '{latitude},{longitude}';
    //   location = location.replace('{latitude}', value['latitude']);
    //   location = location.replace('{longitude}', value['longitude']);
    //   map.gmap('addMarker',{'position':location, 'bounds':false});
    // });
  });
}

$(document).ready(function() {
  $.get('/issues', function(data) {
    console.log('foo');
  });

  var map = $('#map-main');
  map.gmap({
    'center': '46.768322, 23.595002',
    'scrollwheel': false, 
  });

  map.gmap('option', 'zoom', 13);
});
