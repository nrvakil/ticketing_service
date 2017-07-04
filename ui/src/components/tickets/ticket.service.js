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
