var app = angular.module('Ticketing Service', ['ui.router', 'ngMaterial', 'angular-spinkit', 'toastr'])
.run(['$rootScope', '$state', function($rootScope, $state) { }])
.constant("config", {
  apiBase: 'http://localhost:3000/api',
  tokenKey: 'token',
  currentUserKey: 'currentUser'
})
.filter('capitalize', function() {
  return function(input) {
    return (!!input) ? input.charAt(0).toUpperCase() + input.substr(1).toLowerCase() : '';
  }
})
.config(['$httpProvider', function($httpProvider) { $httpProvider.interceptors.push('loader'); }])
.config(function ($httpProvider) { $httpProvider.interceptors.push('AuthInterceptor'); })
