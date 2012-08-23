/* Application module */

define([
	// Framework dependencies
	'jQuery',
	'Underscore',
	'Backbone',
], 

// After loading
function($, _, Backbone, Tasks) {

	// Initialize the main application module
	var initialize = function() {
		console.log("Initializing application...");
	}

	// Make the initialization publicly available
	return {
		initialize: initialize
	};
});