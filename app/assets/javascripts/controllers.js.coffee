'use strict'

class @MyCtrl1
  $inject: []

class @MyCtrl2
  $inject: []

class @SessionCtrl
  $inject: ['$scope', '$http']
  constructor: ($scope, $http) ->
    $scope.logIn = ->
      authString = Base64.encode "#{$scope.username}:#{$scope.password}"
      $http.get('/users/me'
        headers:
          Authorization: "Basic #{authString}"
      ).success( (data) ->
        $scope.username = data.user.username
        $scope.authentication_token = data.user.authentication_token
      ).error( ->
        alert 'failed to log in, please try again'
      )
    $scope.logOut = ->
      $scope.username = null
      $scope.authentication_token = null
      $scope.password = null
    $scope.$watch 'username', ->
      SessionCtrl.username = $scope.username
    $scope.$watch 'authentication_token', ->
      SessionCtrl.authentication_token = $scope.authentication_token
      $scope.isLoggedIn = $scope.authentication_token?
