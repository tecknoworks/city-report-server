/* Require.js configuration and bootstrapping */

require.config({
	// Configure paths to common libraries
	paths: {

		// Framework dependencies
		jQuery: 'lib/jquery',
		Underscore: 'lib/underscore',
		Backbone: 'lib/backbone',

		// Require.js Plugins
		text: 'lib/require/text'
	},

	// Load Timeout
	waitSeconds: 10,

	// Dependency configuration
	shim: {
        'Backbone': {
            //These script dependencies should be loaded before loading
            //backbone.js
            deps: ['Underscore', 'jQuery'],
            //Once loaded, use the global 'Backbone' as the
            //module value.
            exports: 'Backbone'
        },
        
        'Underscore': {
        	deps: [],
        	// Export the underscore variable
        	exports: '_'
        },

        'jQuery': {
        	deps: [],
        	// Export the jQuery function variable
        	exports: '$'
        },
    }
});

// Entry point for require.js
require(
	[
		"app",
	], 
	function(App) {
		// Initialize the application
		App.initialize();
	}
);