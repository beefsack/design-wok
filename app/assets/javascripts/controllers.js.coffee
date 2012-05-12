'use strict'

class @HomeCtrl
  $inject: []

class @DiscoverCtrl
  $inject: []

class @DesignCtrl
  $inject: []

class @EditInPlaceCtrl
  $inject: [ '$scope', '$http' ]
  constructor: ($scope, $http) ->
    $scope.editing = false
    $scope.edit = ->
      $scope.value = $scope.$parent[$scope.field]
      $scope.editing = true
    $scope.save = (value) ->
      data = {}
      data[$scope.$parent.updateApiRootNode] = {}
      data[$scope.$parent.updateApiRootNode][$scope.field] = value
      $http.put($scope.$parent.updateApiUrl, data,
        headers:
          Authorization: SessionCtrl.basicAuthHeaderValue()
      ).success ->
        $scope.$parent[$scope.field] = value
        $scope.cancel()
    $scope.cancel = ->
      $scope.editing = false

class @AccountCtrl
  $inject: [ '$scope', '$http' ]
  constructor: ($scope, $http) ->
    $scope.loaded = false
    $scope.updateApiRootNode = 'user'
    $http.get("/users/me",
      headers:
        Authorization: SessionCtrl.basicAuthHeaderValue()
    ).success (data) ->
      $scope.username = data.user.username
      $scope.email = data.user.email
      $scope.loaded = true
    $scope.$watch 'username', ->
      $scope.updateApiUrl = "/users/#{$scope.username}"

class @AccountRegisterCtrl
  $inject: [ '$scope', '$http' ]
  constructor: ($scope, $http) ->
    $scope.register = (user) ->
      $http.post('/users',
        user:
          username: user.username
          email: user.email
          password: user.password
      ).success ->
        window.location.href = '#'

class @UserShowCtrl
  $inject: [ '$scope', '$http', '$route' ]
  constructor: ($scope, $http, $route) ->
    $http.get("/users/#{$route.current.params.username}").success (data) ->
      $scope.username = data.user.username

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
        window.location.href = '#'
      )
    $scope.logOut = ->
      # Clear local values
      $scope.username = undefined
      $scope.authentication_token = undefined
      $scope.email = undefined
      $scope.password = undefined
      window.location.href = '#'
    $scope.test = ->
      $http.get('/users/testuser',
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
