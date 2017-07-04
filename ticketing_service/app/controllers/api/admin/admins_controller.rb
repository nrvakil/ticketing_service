module Api
  module Admin
    #
    # Api for admin of agents
    #
    # @author [nityamvakil]
    #
    class AdminsController < ApplicationController
      before_filter :authenticate_admin!

      def index
        @users = User.read
        @agents = Agent.read

        render json: { payload: { users: @users, agents: @agents },
                       meta: { users_count: @users.count,
                               agents_count: @agents.count } }
      end

      def ban_user
        @user = user
        @user.update! status: ::States.user.banned
        render json: { payload: @user, meta: { message: 'User banned!' } }
      end

      def activate_user
        @user = user
        @user.update! status: ::States.user.active
        render json: { payload: @user, meta: { message: 'User active!' } }
      end

      def ban_agent
        @user = agent
        @user.update! status: ::States.agent.banned
        ::Agents::Assignment.new(agent: @user).reassign

        render json: { payload: @user, meta: { message: 'Agent banned!' } }
      end

      def approve_agent
        @user = agent.update! status: ::States.agent.approved
        render json: { payload: @user, meta: { message: 'Agent approved!' } }
      end

      private

      def user
        User.find params[:id]
      end

      def agent
        Agent.find params[:id]
      end
    end
  end
end
