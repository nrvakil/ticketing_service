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
