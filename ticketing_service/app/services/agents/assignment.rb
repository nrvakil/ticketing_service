module Agents
  #
  # Agent assignment service for tickets
  #
  # @author [nityamvakil]
  #
  class Assignment
    def initialize(params = {})
      @params = params
    end

    def laziest_agent
      Agent.includes(:tickets).references(:tickets)
           .where(status: ::States.agent.approved, is_admin: false)
           .select('id', 'count(tickets.id) as tickets_count')
           .group(:id).order('tickets_count').entries.first
    end

    def laziest_agent!
      laziest_agent || missing_agents
    end

    def laziest_agent_id
      agent = laziest_agent
      agent ? agent.id : nil
    end

    def laziest_agent_id!
      agent = laziest_agent
      agent ? agent.id : missing_agents
    end

    def reassign
      Ticket.open.where(agent_id: @params[:agent].id)
            .update_all agent_id: laziest_agent_id
    end

    private

    def missing_agents
      raise Exceptions::MissingAgents, 'No agents active at the moment!'
    end
  end
end
