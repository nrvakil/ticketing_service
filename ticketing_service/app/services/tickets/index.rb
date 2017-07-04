module Tickets
  #
  # Index service for tickets
  #
  # @author [nityamvakil]
  #
  class Index
    def initialize(params = {})
      @params = params
    end

    attr_reader :params

    def for_users
      Ticket.joins(:agent).where(user: params[:user]).order(:status)
            .select(selection_for_users).entries.group_by(&:status).as_json
    end

    def for_agents
      Ticket.joins(:user).where(agent: params[:agent]).order(:status)
            .select(selection_for_agents).entries.group_by(&:status).as_json
    end

    private

    def selection_for_users
      'tickets.*, agents.name as agent_name, agents.email as agent_email'
    end

    def selection_for_agents
      'tickets.*, users.name as user_name, users.email as user_email'
    end
  end
end
