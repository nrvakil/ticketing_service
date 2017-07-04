app.controller('AppController', ['$rootScope', '$scope', '$state', '$window',
  function($rootScope, $scope, $state, $window) {
    if (!$scope.code) {
      $state.go('registration');
    }

    $rootScope.$on('InternalServerError', function (event, data) {
      $scope.code = 500;
      $scope.content = 'We are sorry but something went wrong!';

      $state.go('httpError');
    });

    $rootScope.$on('Unauthorized', function (event, data) {
      $scope.code = 401;
      $scope.content = 'You shall not pass!';

      $state.go('httpError');
    });

    $rootScope.$on('NotFound', function (event, data) {
      $scope.code = 404;
      $scope.content = 'The resource you are looking for does not exist!';

      $state.go('httpError');
    });

    $rootScope.$on('HttpError', function (event, data) {
      $scope.code = data.code;
      $scope.content = 'We are unable to reach our servers at the moment! Please try again after some time.';

      $state.go('httpError');
    });
  }
]);
