'use strict'

class @HomeCtrl
  $inject: [ '$rootScope' ]
  constructor: ($rootScope) ->
    $rootScope.pageTitle = 'Home'

class @DiscoverCtrl
  $inject: [ '$rootScope' ]
  constructor: ($rootScope) ->
    $rootScope.pageTitle = 'Discover designs'

class @DesignCtrl
  $inject: [ '$rootScope' ]
  constructor: ($rootScope) ->
    $rootScope.pageTitle = 'Sell designs'

class @EditInPlaceCtrl
  $inject: [ '$scope', '$rootScope', '$http' ]
  constructor: ($scope, $rootScope, $http) ->
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
          Authorization: $rootScope.basicAuthHeaderValue()
      ).success ->
        $scope.$parent[$scope.field] = value
        $scope.cancel()
    $scope.cancel = ->
      $scope.editing = false

class @AccountCtrl
  $inject: [ '$scope', '$rootScope', '$http' ]
  constructor: ($scope, $rootScope, $http) ->
    $scope.loaded = false
    $scope.updateApiRootNode = 'user'
    $http.get("/users/me",
      headers:
        Authorization: $rootScope.basicAuthHeaderValue()
    ).success (data) ->
      $scope.username = data.user.username
      $scope.email = data.user.email
      $scope.loaded = true
    $scope.$watch 'username', ->
      $scope.updateApiUrl = "/users/#{$scope.username}"

class @AccountRegisterCtrl
  $inject: [ '$scope', '$rootScope', '$http' ]
  constructor: ($scope, $rootScope, $http) ->
    $rootScope.pageTitle = 'Register'
    $scope.register = (user) ->
      $http.post('/users',
        user:
          username: user.username
          email: user.email
          password: user.password
      ).success ->
        window.location.href = '#'

class @AccountConfirmCtrl
  $inject: [ '$scope', '$http', '$browser', '$route' ]
  constructor: ($scope, $http, $browser, $route) ->
    $http.post('/users/confirm', {
      confirmation_token: $route.current.params.confirmationToken
    }).success (data) ->
      $browser.cookies 'username', data.user.username
      $browser.cookies 'authentication_token', data.user.authentication_token
      window.location.href = '/'

class @UserShowCtrl
  $inject: [ '$scope', '$http', '$route' ]
  constructor: ($scope, $http, $route) ->
    $http.get("/users/#{$route.current.params.username}").success (data) ->
      $scope.username = data.user.username

class @ApplicationCtrl
  $inject: ['$rootScope', '$http', '$browser']
  constructor: ($scope, $rootScope, $http, $browser) ->
    $rootScope.logIn = (email, password) ->
      # Clear current auth if there is any
      $rootScope.username = undefined
      $rootScope.authentication_token = undefined
      authString = Base64.encode "#{email}:#{password}"
      $http.get('/users/me'
        headers:
          Authorization: "Basic #{authString}"
      ).success (data) ->
        # Set local values
        $rootScope.username = data.user.username
        $rootScope.authentication_token = data.user.authentication_token
        window.location.href = '#'
    $rootScope.logOut = ->
      # Clear local values
      $rootScope.username = undefined
      $rootScope.authentication_token = undefined
      $rootScope.email = undefined
      $rootScope.password = undefined
      window.location.href = '#'
    $rootScope.basicAuthHeaderValue = (username, password) ->
      username = username || $rootScope.authentication_token || ''
      password = password || ''
      return null if username is '' and password is ''
      'Basic ' + Base64.encode "#{username}:#{password}"
    # Set static values and cookie when rootScope values changes
    $rootScope.$watch 'username', ->
      $browser.cookies 'username', $rootScope.username
    $rootScope.$watch 'authentication_token', ->
      $browser.cookies 'authentication_token', $rootScope.authentication_token
      $rootScope.isLoggedIn = $rootScope.authentication_token?
    # Set from cookies on initial display
    cookies = $browser.cookies()
    $rootScope.username = cookies.username
    $rootScope.authentication_token = cookies.authentication_token
