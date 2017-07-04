module Tickets
  #
  # CRUD service for tickets
  #
  # @author [nityamvakil]
  #
  class Crud
    def initialize(params = {})
      @params = params
    end

    attr_reader :params

    def create
      assign_agent
      Ticket.create! params
    end

    def update
      Ticket.find(params[:id]).update! params
    end

    private

    def assign_agent
      params.merge! agent: Agents::Assignment.new.laziest_agent!
    end
  end
end
