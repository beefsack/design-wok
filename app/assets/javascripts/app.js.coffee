'use strict'

# Declare app level module which depends on filters, and services
angular.module('designPig', [
  'designPig.filters'
  'designPig.services'
  'designPig.directives'
]).config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/view1',
    template: 'assets/partial1.html'
    controller: MyCtrl1
  $routeProvider.when '/view2',
    template: 'assets/partial2.html'
    controller: MyCtrl2
  $routeProvider.otherwise
    redirectTo: '/view1'
])
