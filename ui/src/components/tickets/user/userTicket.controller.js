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
