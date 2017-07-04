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
