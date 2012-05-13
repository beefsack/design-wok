'use strict'

# Declare app level module which depends on filters, and services
angular.module('designWok', [
  'designWok.filters'
  'designWok.services'
  'designWok.directives'
]).config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/:locale/user/:username',
    template: 'assets/user/show.html'
    controller: UserShowCtrl
  $routeProvider.when '/:locale/discover',
    template: 'assets/discover.html'
    controller: DiscoverCtrl
  $routeProvider.when '/:locale/design',
    template: 'assets/design.html'
    controller: DesignCtrl
  $routeProvider.when '/:locale/account/register',
    template: 'assets/account/register.html'
    controller: AccountRegisterCtrl
  $routeProvider.when '/:locale/account/confirm/:confirmationToken',
    template: 'assets/account/confirm.html'
    controller: AccountConfirmCtrl
  $routeProvider.when '/:locale/account',
    template: 'assets/account.html'
    controller: AccountCtrl
  $routeProvider.when '/'
    redirectTo: 'cn'
  $routeProvider.when '/:locale',
    template: 'assets/home.html'
    controller: HomeCtrl
]).config(['$httpProvider', ($httpProvider) ->
  # HTTP Auth
  $httpProvider.responseInterceptors.push ($q) ->
    return (promise) ->
      return promise.then((response) ->
        # Success
        return response
      , (response) ->
        # Error
        alert 'couldn\'t authenticate' if response.status is 401
        return $q.reject(response);
      )
  return $httpProvider
])
