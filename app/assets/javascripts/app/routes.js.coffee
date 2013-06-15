@app.config ['$routeProvider', (router) ->
  router
    .when('/not-found', templateUrl: 'templates/not-found')
    .otherwise(redirectTo: '/not-found')
]

# @app.config ($locationProvider) -> $locationProvider.html5Mode true
