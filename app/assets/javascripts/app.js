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

	}

	// Make the initialization publicly available
	return {
		initialize: initialize
	};
});
