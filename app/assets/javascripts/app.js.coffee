'use strict'

# Declare app level module which depends on filters, and services
angular.module('designPig', [
  'designPig.filters'
  'designPig.services'
  'designPig.directives'
]).config(['$routeProvider', ($routeProvider) ->
  # Routes
  $routeProvider.when '/discover',
    template: 'assets/discover.html'
    controller: DiscoverCtrl
  $routeProvider.when '/design',
    template: 'assets/design.html'
    controller: DesignCtrl
  $routeProvider.otherwise
    template: 'assets/home.html'
    controller: HomeCtrl
]).config(['$httpProvider', ($httpProvider) ->
  # HTTP Auth
  $httpProvider.responseInterceptors.push ($q) ->
    return (promise) ->
      window.egg = promise
      return promise.then((response) ->
        return response
        # Success
      , (response) ->
        # Error
        alert 'couldn\'t authenticate' if response.status is 401
        return $q.reject(response);
      )
  return $httpProvider
])
