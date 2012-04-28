'use strict'

class @HomeCtrl
  $inject: []

class @DiscoverCtrl
  $inject: []

class @DesignCtrl
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
        window.location.reload false
      )
    $scope.logOut = ->
      # Clear local values
      $scope.username = undefined
      $scope.authentication_token = undefined
      $scope.email = undefined
      $scope.password = undefined
      window.location.href = '/'
    $scope.test = ->
      $http.get('/users',
        headers:
          Authorization: SessionCtrl.basicAuthHeaderValue()
      ).success (data) ->
        console.log data
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
SessionCtrl.basicAuthHeaderValue = (username, password) ->
  username = username || SessionCtrl.authentication_token || ''
  password = password || ''
  return null if username is '' and password is ''
  'Basic ' + Base64.encode "#{username}:#{password}"
