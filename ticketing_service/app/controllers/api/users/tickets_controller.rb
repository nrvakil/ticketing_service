module Api
  module Users
    #
    # Tickets api for users
    #
    # @author [nityamvakil]
    #
    class TicketsController < ApplicationController
      before_filter :authenticate_user!
      before_filter :validate_user_status, except: [:index]

      def index
        @tickets = ::Tickets::Index.new(user).for_users
        render json: { payload: @tickets, meta: { count: @tickets.count } }
      end

      def create
        @ticket = ::Tickets::Crud.new(ticket_params).create
        render json: { payload: @ticket,
                       meta: { message: 'Successfully created!' } }
      end

      def update
        @ticket = ::Tickets::Crud.new(ticket_params).update
        render json: { payload: @ticket,
                       meta: { message: 'Successfully updated!' } }
      end

      def withdraw
        @ticket = ::Ticket.find_by! user.merge id: params[:id]
        @ticket.update! status: ::States.ticket.withdrawn
        render json: { payload: @ticket,
                       meta: { message: 'Ticket withdrawn!' } }
      end

      def reopen
        @ticket = ::Ticket.find_by! user.merge id: params[:id]
        @ticket.update! status: ::States.ticket.raised,
                        closed_on: nil,
                        agent_id: ::Agents::Assignment.new.laziest_agent_id!

        render json: { payload: @ticket,
                       meta: { message: 'Ticket reopend!' } }
      end

      private

      def validate_user_status
        raise Exceptions::Unauthorized, 'You are not active!' unless
          @current_user.status == 'active'
      end

      def user
        { user: @current_user }
      end

      def ticket_params
        params.permit(*permitted_columns.flatten).merge user
      end

      def permitted_columns
        ::Ticket.column_names - %w(created_at updated_at logs deadline agent_id)
      end
    end
  end
end
