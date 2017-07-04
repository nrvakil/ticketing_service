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
