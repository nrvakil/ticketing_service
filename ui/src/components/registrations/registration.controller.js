app.controller('RegistrationController', ['RegistrationService', '$rootScope', '$scope', '$state', '$window', 'toastr',
  function(RegistrationService, $rootScope, $scope, $state, $window, toastr) {
    var self = this;

    self.loginCredentials = { email: "", password: "", is_agent: false };
    self.signupCredentials = { name: "", email: "", password: "", is_agent: false };
    self.template = 'login';

    self.currentUser = function() {
      return RegistrationService.currentUser();
    }

    self.switchToSignup = function() {
      self.template = 'signup';
      self.signupCredentials.email = self.loginCredentials.email;
    };

    self.switchToLogin = function() {
      self.template = 'login';
      self.loginCredentials.email = self.signupCredentials.email;
    };

    self.signup = function() {
      RegistrationService.signup(self.signupCredentials).then(function(response) {
        toastr.success(response.data.meta.message);
        self.template = 'login';
      }, function(error) {
        var msg = error.data.errors.message;
        toastr.error(msg, 'Error!');
      });
    };

    self.login = function() {
      RegistrationService.login(self.loginCredentials).then(function(response) {
        RegistrationService.setUser(response.data.payload);
        redirect();
      }, function(error) {
        var msg = error.data.errors.message;
        toastr.error(msg, 'Error!');
      });
    };

    self.logout = function () {
      RegistrationService.logout();
      $state.go('registration');
    };

    var redirect = function() {
      var currentUser = RegistrationService.currentUser();

      if (currentUser.is_agent) {
        if (currentUser.is_admin) {
          $state.go('admin');
        } else {
          $state.go('agent-tickets');
        }
      } else {
        $state.go('user-tickets');
      }
    }

    var checkLoggedIn = function () {
      if (RegistrationService.isLoggedIn()) {
        redirect()
      };
    };

    checkLoggedIn();
  }
]);
