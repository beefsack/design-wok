'use strict'

class @MyCtrl1
  $inject: []

class @MyCtrl2
  $inject: []

class @SessionCtrl
  $inject: ['$scope', '$http']
  constructor: ($scope, $http) ->
    $scope.logIn = ->
      $scope.usertoken = $scope.username
    $scope.logOut = ->
      $scope.username = null
      $scope.password = null
      $scope.usertoken = null
    $scope.$watch 'usertoken', ->
      $scope.isLoggedIn = $scope.usertoken?
