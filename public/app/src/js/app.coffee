app = angular.module('app', ['ngRoute', 'ngStorage', 'ngMaterial', 'uiGmapgoogle-maps'])

app.config ['$mdThemingProvider', '$mdIconProvider', ($mdThemingProvider, $mdIconProvider) ->
  $mdIconProvider
    .defaultIconSet('./assets/svg/avatars.svg', 128)
    .icon('menu', './assets/svg/menu.svg', 24)
    .icon('share', './assets/svg/share.svg', 24)
    .icon('google_plus', './assets/svg/google_plus.svg', 512)
    .icon('hangouts', './assets/svg/hangouts.svg', 512)
    .icon('twitter', './assets/svg/twitter.svg', 512)
    .icon('phone', './assets/svg/phone.svg', 512)
    .icon('upvote', './assets/svg/ic_plus_one_48px.svg', 512)
    .icon('home', './assets/svg/ic_home_48px.svg', 512)
    .icon('event', './assets/svg/ic_event_48px.svg', 512)
    .icon('label', './assets/svg/ic_label_48px.svg', 512)
    .icon('add', './assets/svg/ic_add_48px.svg', 512)
    .icon('gps', './assets/svg/ic_gps_fixed_48px.svg', 512)
    .icon('camera', './assets/svg/ic_add_a_photo_black_48px.svg', 512)
    .icon('photo', './assets/svg/ic_insert_photo_48px.svg', 512)

  $mdThemingProvider.theme('default')
    # .primaryPalette('deep-purple')
    .accentPalette('pink')
    .warnPalette('red')
    .backgroundPalette('grey')
    # .dark()

  return
]

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when('/map', templateUrl: 'views/map.html', controller: 'MapController')
    .when('/about', templateUrl: 'views/about.html', controller: 'SimpleController')
    .when('/about/:language', templateUrl: 'views/about.html', controller: 'SimpleController')
    .when('/eula', templateUrl: 'views/eula.html', controller: 'SimpleController')
    .when('/eula/:language', templateUrl: 'views/eula.html', controller: 'SimpleController')
    .otherwise(redirectTo: '/map')
  return
]

app.config(['$localStorageProvider', ($localStorageProvider) ->
  # $localStorageProvider.get('MyKey');
  # $localStorageProvider.set('MyKey', { k: 'value' });
  $localStorageProvider.setKeyPrefix 'city-report'
  return
])

app.config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure
    key: 'AIzaSyAPflAdoz3viwmzkDJtMyf1-YGDA3xCYmo'
    v: '3.22'
    # libraries: 'weather,geometry,visualization'
  return

# Needed for google maps clicking to work on mobile
app.config ['$mdGestureProvider', ($mdGestureProvider) ->
  $mdGestureProvider.skipClickHijack()
]

app.run ['CityReportFactory', '$rootScope', (CityReportFactory, $rootScope) ->
  CityReportFactory.updateMeta().then((data) ->
    console.log data
    $rootScope.meta = data
  )
]
