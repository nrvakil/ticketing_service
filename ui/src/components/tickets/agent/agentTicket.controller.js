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
