/*=============================================================================
*
* 	Main application module, gets loaded on any page
*
*=============================================================================*/

define([
	// Framework dependencies
	'jQuery',
	'Underscore',
	'Backbone',

	// Google maps
	'Maps',

	// Bootstrap
	'Bootstrap',
], 

// After loading

function($, _, Backbone, Maps) {

  var loadPinpoints = function() {
    var map = $('#map-main');
    $.get("/issues", function(data) {
      $.each(data["response"]["issues"], function(index, value) {
        var location = '{latitude},{longitude}';
        location = location.replace('{latitude}', value['latitude']);
        location = location.replace('{longitude}', value['longitude']);
        map.gmap('addMarker',{'position':location, 'bounds':false});
      });
    });
  }

	// Initialize the main application module
	var initialize = function() {


		// Initialize the map
		var map = $('#map-main');
		map.gmap({ 

			// Center on Cluj
			'center': '46.768322, 23.595002',

			// Disable scroll
			'scrollwheel': false,

		});
		
		// Set a detailed zoom
		map.gmap('option', 'zoom', 13);
		
		// Bind any actions (loading the markers should happen here)
		map.gmap().bind('init', function(ev, map) {
			$('#map-main').gmap('addMarker', {'position': '46.784076, 23.603388', 'bounds': false});
		});

    // Load all pinpoints
    loadPinpoints();

	}


	// Make the initialization publicly available
	return {
		initialize: initialize,
	};
});
