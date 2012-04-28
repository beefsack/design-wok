'use strict'

class @MyCtrl1
  $inject: []

class @MyCtrl2
  $inject: []

class @SessionCtrl
  $inject: ['$scope', '$http', '$browser']
  constructor: ($scope, $http, $browser) ->
    $scope.logIn = ->
      # Clear current auth if there is any
      $scope.username = undefined
      $scope.authentication_token = undefined
      authString = Base64.encode "#{$scope.email}:#{$scope.password}"
      $http.get('/users/me'
        headers:
          Authorization: "Basic #{authString}"
      ).success( (data) ->
        # Set local values
        $scope.username = data.user.username
        $scope.authentication_token = data.user.authentication_token
      )
    $scope.logOut = ->
      # Clear local values
      $scope.username = undefined
      $scope.authentication_token = undefined
      $scope.email = undefined
      $scope.password = undefined
    # Set static values and cookie when scope values changes
    $scope.$watch 'username', ->
      SessionCtrl.username = $scope.username
      $browser.cookies 'username', $scope.username
    $scope.$watch 'authentication_token', ->
      SessionCtrl.authentication_token = $scope.authentication_token
      $browser.cookies 'authentication_token', $scope.authentication_token
      $scope.isLoggedIn = $scope.authentication_token?
    # Set from cookies on initial display
    cookies = $browser.cookies()
    $scope.username = cookies.username
    $scope.authentication_token = cookies.authentication_token
