app.factory('RegistrationService', ['config', '$http', '$rootScope', '$window',
  function(config, $http, $rootScope, $window) {
    return {
      signup: function(params) {
        return $http.post(config.apiBase + "/auth/signup", params);
      },

      login: function(params) {
        return $http.post(config.apiBase + "/auth/login/", params);
      },

      setUser: function(payload) {
        $rootScope.loggedIn = true;
        $window.localStorage.setItem(config.tokenKey, payload.token);
        $window.localStorage.setItem(config.currentUserKey, JSON.stringify(payload));
      },

      currentUser: function() {
        return JSON.parse($window.localStorage.getItem(config.currentUserKey));
      },

      isLoggedIn: function() {
        var token = $window.localStorage.getItem(config.tokenKey);
        return !_.isEmpty(token);
      },

      logout: function() {
        $window.localStorage.clear();
        $rootScope.loggedIn = false;
      },

      token: function() {
        return $window.localStorage.getItem(config.tokenKey);
      }
    };
  }
]);
