/* Application module */

define([
	// Framework dependencies
	'jQuery',
	'Underscore',
	'Backbone',
	'Less',
], 

// After loading
function($, _, Backbone, less) {

	// Initialize the main application module
	var initialize = function() {
		console.log("Initializing application...");

		console.log("Starting less...");
		less.watch();
	}

	// Make the initialization publicly available
	return {
		initialize: initialize
	};
});
