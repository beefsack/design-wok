'use strict'

class @MyCtrl1
  $inject: []

class @MyCtrl2
  $inject: []

class @SessionCtrl
  $inject: ['$scope', '$http']
  constructor: ($scope, $http) ->
    $scope.logIn = (username, password) ->
      alert "Loggin in as #{username} #{password}"
    $scope.logOut = ->
      alert "Logout"
    $scope.isLoggedIn = false
