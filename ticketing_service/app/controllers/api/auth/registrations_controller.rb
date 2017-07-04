module Api
  module Auth
    #
    # API for user registration and login
    #
    # @author [nityamvakil]
    #
    class RegistrationsController < ApplicationController
      before_filter :authenticate!, except: [:signup, :login, :agent_signup, :agent_login]

      def signup
        @user = params[:is_agent] ? create_agent : create_user
        render json: { payload: @user,
                       meta: { message: 'Signed up successfully!' } }
      end

      def login
        @user = params[:is_agent] ? authenticate_agent : authenticate_user
        raise Exceptions::Unauthorized, 'Invalid email/password' unless @user

        render json: { payload: params[:is_agent] ? agent_payload : user_payload }
      end

      private

      def user_payload
        key = { id: @user.id, is_agent: false, is_admin: false }
        key.merge! details key
      end

      def agent_payload
        key = { id: @user.id, is_agent: true, is_admin: @user.is_admin }
        key.merge! details key
      end

      def details(key)
        { name: @user.name, email: @user.email, token: ::JsonWebToken.encode(key) }
      end

      def create_user
        ::User.create! user_params
      end

      def create_agent
        ::Agent.create! agent_params
      end

      def authenticate_user
        ::User.find_by!(email: params[:email].to_s.downcase)
              .try(:authenticate, params[:password])
      end

      def authenticate_agent
        ::Agent.find_by!(email: params[:email].to_s.downcase)
               .try(:authenticate, params[:password])
      end

      def user_params
        params.permit(*permitted_columns_user.flatten)
      end

      def permitted_columns_user
        ::User.column_names - %w(created_at updated_at password_digest) +
          [:password]
      end

      def agent_params
        params.permit(*permitted_columns_agent.flatten)
      end

      def permitted_columns_agent
        ::Agent.column_names - %w(created_at updated_at password_digest) +
          [:password]
      end
    end
  end
end
