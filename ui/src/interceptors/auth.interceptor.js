app.factory('AuthInterceptor', ['$window', '$rootScope', '$q', 'config', function ($window, $rootScope, $q, config) {
  return {
    request: function(c) {
      c.headers = c.headers || {};

      if ($window.localStorage.getItem(config.tokenKey)) {
        c.headers.Authorization = $window.localStorage.getItem(config.tokenKey);
        $rootScope.loggedIn = true;
      } else {
        $rootScope.loggedIn = false;
      }

      return c || $q.when(c);
    },
    response: function(response) {
      return response || $q.when(response);
    }
  };
}]);
