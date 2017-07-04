module Api
  module Agents
    #
    # Tickets api for agents
    #
    # @author [nityamvakil]
    #
    class TicketsController < ApplicationController
      before_filter :authenticate_agent!, except: [:monthly_report]
      before_filter :validate_agent_status, except: [:index, :monthly_report]

      def index
        @tickets = ::Tickets::Index.new(agent).for_agents
        render json: { payload: @tickets, meta: { count: @tickets.count } }
      end

      def processing
        @ticket = ::Ticket.find_by! ticket_params
        @ticket.update! status: ::States.ticket.processing
        render json: { payload: @ticket, meta: { message: 'Ticket under processing!' } }
      end

      def resolve
        @ticket = ::Ticket.find_by! ticket_params
        @ticket.update! status: ::States.ticket.resolved
        render json: { payload: @ticket, meta: { message: 'Ticket resolved!' } }
      end

      def reject
        @ticket = ::Ticket.find_by! ticket_params
        @ticket.update! status: ::States.ticket.rejected
        render json: { payload: @ticket, meta: { message: 'Ticket rejected!' } }
      end

      def monthly_report
        @obj = ::Tickets::Pdf.new

        respond_to do |format|
          format.html
          format.pdf do
            pdf = @obj.last_month_report
            send_data pdf.render, filename: @obj.filename,
                                  type: 'application/pdf'
          end
        end
      end

      private

      def validate_agent_status
        raise Exceptions::Unauthorized, 'You are not approved!' unless
          @current_user.status == 'approved'
      end

      def ticket_params
        agent.merge id: params[:id]
      end

      def agent
        { agent: @current_user }
      end
    end
  end
end
