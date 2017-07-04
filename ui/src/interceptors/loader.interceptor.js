app.factory('loader', ['$q', '$rootScope', function($q, $rootScope) {
  var api_url_prefix = '/api';
  var request_count = 0;
  var response_count = 0;

  return {
    request: function(config) {
      $rootScope.showUi = false;
      request_count += 1;

      return config;
    },

    response: function(result) {
      var url = result.config.url;
      response_count += 1;

      if (response_count === request_count) {
        $rootScope.showUi = true;
      }

      return result;
    },

    responseError: function(rejection) {
      response_count += 1;
      $rootScope.showUi = true;

      if (rejection.config.url.search('login') > 0) {
        return $q.reject(rejection);
      }

      switch (rejection.status) {
        case 500:
          $rootScope.$broadcast('InternalServerError');
          break;
        case 400:
          $rootScope.$broadcast('BadRequest', rejection.data.errors);
          break;
        case 401:
          $rootScope.$broadcast('Unauthorized', rejection.data.errors);
          break;
        case 404:
          $rootScope.$broadcast('NotFound', rejection.data.errors);
          break;
        default:
          $rootScope.$broadcast('HttpError', { code: rejection.status });
          break;
      }

      return $q.reject(rejection);
    }
  };
}]);
