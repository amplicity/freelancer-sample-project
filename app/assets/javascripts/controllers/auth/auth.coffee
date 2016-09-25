App.angular.controller(
  'AuthController'
  [
    '$scope'
    '$state'
    'Auth'
    'Notification'
    ($scope, $state, Auth, Notification) ->
      $scope.login = () ->
        Auth.login($scope.user).then(
          () ->
            $state.go('home')
          (resp)->
            Notification.error(resp.data.error)
        )

      $scope.register = () ->
        Auth.register($scope.user).then(
          ()->
            $state.go('home')
          (resp)->
            if resp.data.errors.email?
              resp.data.errors.email.map((i) ->
                Notification.error("Email #{i}")
              )
            else if resp.data.errors.password?
              resp.data.errors.password.map((i) ->
                Notification.error("Password #{i}")
              )
        )
  ]
)