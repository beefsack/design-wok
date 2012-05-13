'use strict'

class @HomeCtrl
  $inject: [ '$scope' ]
  constructor: ($scope) ->
    $scope.application.category = null
    $scope.application.subTitle = 'home_page.title'

class @DiscoverCtrl
  $inject: [ '$scope' ]
  constructor: ($scope) ->
    $scope.application.category = 'discover'
    $scope.application.subTitle = 'discover_page.title' # The lang offset

class @DesignCtrl
  $inject: [ '$scope' ]
  constructor: ($scope) ->
    $scope.application.category = 'design'
    $scope.application.subTitle = 'design_page.title' # The lang offset

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
          Authorization: $scope.application.session.basicAuthHeaderValue()
      ).success ->
        $scope.$parent[$scope.field] = value
        $scope.cancel()
    $scope.cancel = ->
      $scope.editing = false

class @AccountCtrl
  $inject: [ '$scope', '$http' ]
  constructor: ($scope, $http) ->
    $scope.application.category = 'myAccount'
    $scope.application.subTitle = 'My account'
    $scope.loaded = false
    $scope.updateApiRootNode = 'user'
    $http.get("/users/me",
      headers:
        Authorization: $scope.application.session.basicAuthHeaderValue()
    ).success (data) ->
      $scope.username = data.user.username
      $scope.email = data.user.email
      $scope.loaded = true
    $scope.$watch 'username', ->
      $scope.updateApiUrl = "/users/#{$scope.username}"

class @AccountRegisterCtrl
  $inject: [ '$scope', '$http' ]
  constructor: ($scope, $http) ->
    $scope.application.category = 'myAccount'
    $scope.application.subTitle = 'Register'
    $scope.register = (user) ->
      $http.post('/users',
        user:
          username: user.username
          email: user.email
          password: user.password
      ).success ->
        window.location.href = '#'

class @AccountConfirmCtrl
  $inject: [ '$scope', '$http', '$browser', '$routeParams' ]
  constructor: ($scope, $http, $browser, $routeParams) ->
    $http.post('/users/confirm', {
      confirmation_token: $routeParams.confirmationToken
    }).success (data) ->
      $browser.cookies 'username', data.user.username
      $browser.cookies 'authentication_token', data.user.authentication_token
      window.location.href = '/'

class @UserShowCtrl
  $inject: [ '$scope', '$http', '$routeParams' ]
  constructor: ($scope, $http, $routeParams) ->
    $http.get("/users/#{$routeParams.username}").success (data) ->
      $scope.username = data.user.username

class @ApplicationCtrl
  $inject: ['$scope', '$http', '$browser', '$routeParams']
  constructor: ($scope, $http, $browser, $routeParams) ->
    $scope.application =
      category: null
      subTitle: 'Home'
      session: {}
    $scope.application.session.logIn = (email, password) ->
      # Clear current auth if there is any
      $scope.application.session.username = undefined
      $scope.application.session.authentication_token = undefined
      authString = Base64.encode "#{email}:#{password}"
      $http.get('/users/me'
        headers:
          Authorization: "Basic #{authString}"
      ).success (data) ->
        # Set local values
        $scope.application.session.username = data.user.username
        $scope.application.session.authentication_token =
          data.user.authentication_token
        window.location.href = '#'
    $scope.application.session.logOut = ->
      # Clear local values
      $scope.application.session.username = undefined
      $scope.application.session.authentication_token = undefined
      $scope.application.session.email = undefined
      $scope.application.session.password = undefined
      window.location.href = '#'
    $scope.application.session.basicAuthHeaderValue = (username, password) ->
      username = username || $scope.application.session.authentication_token || ''
      password = password || ''
      return null if username is '' and password is ''
      'Basic ' + Base64.encode "#{username}:#{password}"
    # Set static values and cookie when scope values changes
    $scope.$watch 'application.session.username', ->
      $browser.cookies 'username', $scope.application.session.username
    $scope.$watch 'application.session.authentication_token', ->
      $browser.cookies 'authentication_token',
        $scope.application.session.authentication_token
      $scope.application.session.isLoggedIn =
        $scope.application.session.authentication_token?
    # Set from cookies on initial display
    cookies = $browser.cookies()
    $scope.application.session.username = cookies.username
    $scope.application.session.authentication_token =
      cookies.authentication_token
    # Set the locale
    $scope.$on '$afterRouteChange', ->
      $scope.application.locale = $routeParams.locale
