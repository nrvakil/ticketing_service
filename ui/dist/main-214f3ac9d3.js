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

app.config(
  ['$stateProvider', '$urlRouterProvider', '$locationProvider',
    function($stateProvider, $urlRouterProvider, $locationProvider) {
      'use strict';

      $stateProvider
        .state('registration', {
          url: '/registration',
          templateUrl: 'src/components/registrations/main.html',
          controller: 'RegistrationController as regCtrl'
        })
        .state('user-tickets', {
          url: '/tickets-user',
          templateUrl: 'src/components/tickets/user/main.html',
          controller: 'UserTicketController as userTicketCtrl'
        })
        .state('agent-tickets', {
          url: '/tickets-agent',
          templateUrl: 'src/components/tickets/agent/main.html',
          controller: 'AgentTicketController as agentTicketCtrl'
        })
        .state('admin', {
          url: '/admin',
          templateUrl: 'src/components/admin/main.html',
          controller: 'AdminController as adminCtrl'
        })
        .state('httpError', {
          url: '/httpError',
          templateUrl: 'src/shared/templates/httpError.html',
          controller: "AppController as appCtrl"
        });

      $urlRouterProvider.otherwise('/registration');
    }
  ]);

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

app.controller('AdminController', ['AdminService', '$scope', '$state', 'toastr',
  function(AdminService, $scope, $state, toastr) {
    var self = this;
    var metadata = AdminService.get_metadata();

    self.statusLabel = function(status) {
      return metadata.statusLabel[status];
    };

    var index = function() {
      AdminService.index().then(function(response) {
        assign(response.data.payload, response.data.meta)
      }, function(error) {
        toastr.error(error.data.errors.message, 'Error!');
      });
    };

    var assign = function(payload, meta) {
      self.users = payload.users;
      self.agents = payload.agents;
      self.users_count = meta.users_count;
      self.agents_count = meta.agents_count;
    };

    var clear = function() {
      self.users = [];
      self.agents = [];
      self.users_count = 0;
      self.agents_count = 0;
    };

    self.banUser = function(row) {
      statusChangeCaller(AdminService.banUser, row)
    };

    self.activateUser = function(row) {
      statusChangeCaller(AdminService.activateUser, row)
    };

    self.banAgent = function(row) {
      statusChangeCaller(AdminService.banAgent, row)
    };

    self.approveAgent = function(row) {
      statusChangeCaller(AdminService.approveAgent, row)
    };

    var statusChangeCaller = function(call, params) {
      call(params).then(function(response) {
        row = response.data.payload;
        toastr.success('Success!', response.data.meta.message);
        index();
      }, function(error) {
        var msg = error.data.errors.message;
        toastr.error(msg, 'Error!');
      });
    };

    index();
  }
]);

app.factory('AdminService', ['config', '$http',
  function(config, $http) {
    var metadata = {
      statusLabel: {
        approved: 'label-warning',
        active: 'label-success',
        banned: 'label-danger',
        registered: 'label-info'
      }
    };

    return {
      get_metadata: function() {
        return metadata;
      },

      index: function() {
        return $http.get(config.apiBase + "/admin/admins/");
      },

      banUser: function(params) {
        return $http.post(config.apiBase + "/admin/ban_user/" + params.id);
      },

      activateUser: function(params) {
        return $http.post(config.apiBase + "/admin/activate_user/" + params.id);
      },

      banAgent: function(params) {
        return $http.post(config.apiBase + "/admin/ban_agent/" + params.id);
      },

      approveAgent: function(params) {
        return $http.post(config.apiBase + "/admin/approve_agent/" + params.id);
      }
    };
  }
]);

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

app.factory('TicketService', ['config', '$http',
  function(config, $http) {
    var metadata = {
      statusLabel: {
        raised: 'label-primary',
        processing: 'label-warning',
        resolved: 'label-success',
        rejected: 'label-danger',
        withdrawn: 'label-info'
      }
    };

    return {
      get_metadata: function() {
        return metadata;
      },

      user: {
        index: function(params) {
          return $http.get(config.apiBase + "/users/tickets", params);
        },

        create: function(params) {
          return $http.post(config.apiBase + "/users/tickets", params);
        },

        update: function(params) {
          return $http.put(config.apiBase + "/users/tickets/" + params.id, params);
        },

        withdraw: function(params) {
          return $http.post(config.apiBase + "/users/ticket-withdraw/" + params.id);
        },

        reopen: function(params) {
          return $http.post(config.apiBase + "/users/ticket-reopen/" + params.id);
        }
      },

      agent: {
        index: function(params) {
          return $http.get(config.apiBase + "/agents/tickets", params);
        },

        process: function(params) {
          return $http.post(config.apiBase + "/agents/ticket-process/" + params.id);
        },

        resolve: function(params) {
          return $http.post(config.apiBase + "/agents/ticket-resolve/" + params.id);
        },

        reject: function(params) {
          return $http.post(config.apiBase + "/agents/ticket-reject/" + params.id);
        },

        report: function() {
          return config.apiBase + "/agents/report.pdf";
        }
      }
    };
  }
]);

app.controller('AgentTicketController', ['TicketService', '$scope', '$state', '$window', 'toastr',
  function(TicketService, $scope, $state, $window, toastr) {
    var self = this;

    var metadata = TicketService.get_metadata();
    self.title = metadata.title;
    self.template = 'list';

    self.statusLabel = function(status) {
      return metadata.statusLabel[status];
    };

    self.isProcessable = function(ticket) {
      return ticket.status == 'raised';
    };

    self.isResolvable = function(ticket) {
      return ticket.status == 'processing';
    };

    self.isRejectable = function(ticket) {
      return ticket.status != 'rejected' && ticket.status != 'withdrawn' && ticket.status != 'resolved';
    };

    self.process = function(ticket) {
      statusUpdateCall(TicketService.agent.process, ticket);
    };

    self.resolve = function(ticket) {
      statusUpdateCall(TicketService.agent.resolve, ticket);
    };

    self.reject = function(ticket) {
      statusUpdateCall(TicketService.agent.reject, ticket);
    };

    self.report = function() {
      $window.open(TicketService.agent.report());
    };

    var ticketsIndex = function() {
      TicketService.agent.index().then(function(response) {
        self.rows = response.data.payload;
        self.template = 'list';
      }, function(error) {
        self.rows = [];
        toastr.error(error.data.errors.message, 'Error!');
      });
    };

    var statusUpdateCall = function(call, ticket) {
      call(ticket).then(function(response) {
        ticket = response.data.payload;
        toastr.success('Success!', response.data.meta.message);
        ticketsIndex();
      }, function(error) {
        var msg = error.data.errors.message;
        toastr.error(msg, 'Error!');
      });
    }

    ticketsIndex();
  }
]);

app.controller('UserTicketController', ['TicketService', '$scope', '$state', 'toastr',
  function(TicketService, $scope, $state, toastr) {
    var self = this;

    var metadata = TicketService.get_metadata();
    self.title = metadata.title;
    self.template = 'list';

    self.statusLabel = function(status) {
      return metadata.statusLabel[status];
    };

    self.isEditable = function(ticket) {
      return ticket.status == 'raised';
    };

    self.isWithdrawable = function(ticket) {
      return ticket.status == 'raised' || ticket.status == 'processing';
    };

    self.isReopenable = function(ticket) {
      return ticket.status == 'rejected' || ticket.status == 'resolved' || ticket.status == 'withdrawn';
    };

    self.new = function() {
      self.editing = {};
      self.template = 'edit';
    };

    self.edit = function(ticket) {
      self.editing = ticket;
      self.template = 'edit';
    };

    self.create = function() {
      statusUpdateCall(TicketService.user.create, self.editing);
    };

    self.update = function() {
      statusUpdateCall(TicketService.user.update, self.editing);
    };

    self.withdraw = function(ticket) {
      statusUpdateCall(TicketService.user.withdraw, ticket);
    };

    self.reopen = function(ticket) {
      statusUpdateCall(TicketService.user.reopen, ticket);
    };

    var ticketsIndex = function() {
      TicketService.user.index().then(function(response) {
        self.rows = response.data.payload;
        self.template = 'list';
      }, function(error) {
        self.rows = [];
        toastr.error(error.data.errors.message, 'Error!');
      });
    };

    var statusUpdateCall = function(call, ticket) {
      call(ticket).then(function(response) {
        ticket = response.data.payload;
        toastr.success('Success!', response.data.meta.message);
        ticketsIndex();
      }, function(error) {
        var msg = error.data.errors.message;
        toastr.error(msg, 'Error!');
      });
    }

    ticketsIndex();
  }
]);
