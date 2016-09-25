App.angular.config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->

    onEnterAuth =
        [
          '$state', 'Auth', ($state, Auth) ->
            Auth.currentUser().then(()->
              $state.go('home')
          )
        ]

    #checking if need authorization for state
    authenticate = ($q, $state, $timeout, Auth) ->
      if Auth.isAuthenticated()
        return $q.when()
      else
        $timeout(()->
          $state.go('login')
          $q.reject('')
        )

    $stateProvider
      .state('home',
        url: '/home'
        templateUrl: 'controllers/events/_events.html'
        controller: 'EventsController'
        resolve:
          authenticate: authenticate

    )
      .state('login',
          url: '/login'
          templateUrl: 'controllers/auth/_login.html'
          controller: 'AuthController'
          onEnter: onEnterAuth
      )
      .state('register',
          url: '/register'
          templateUrl: 'controllers/auth/_register.html'
          controller: 'AuthController'
          onEnter: onEnterAuth
      )

    $urlRouterProvider.otherwise('home')
])