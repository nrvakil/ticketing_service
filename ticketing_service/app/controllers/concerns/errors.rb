#
# Exception redirection module
#
# @author [nityamvakil]
#
module Errors
  extend ActiveSupport::Concern
  # include Exceptions

  def self.included(base)
    base.rescue_from Exception, with: :render_server_error
    base.rescue_from Net::OpenTimeout, with: :render_gateway_timeout
    base.rescue_from ArgumentError, with: :render_server_error
    base.rescue_from ActionController::RoutingError, with: :render_not_found

    base.rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    base.rescue_from ActiveRecord::StatementInvalid, with: :render_bad_request
    base.rescue_from ActiveRecord::UnknownAttributeError, with: :render_bad_request
    base.rescue_from ActiveRecord::RecordInvalid, with: :render_bad_request
    base.rescue_from ActiveRecord::RecordNotUnique, with: :render_bad_request
    base.rescue_from ActiveRecord::InvalidForeignKey, with: :render_bad_request
    base.rescue_from ActiveRecord::RecordNotUnique, with: :render_bad_request
    base.rescue_from ActiveModel::ForbiddenAttributesError, with: :render_forbidden
    base.rescue_from ActiveModel::MissingAttributeError, with: :render_forbidden
    base.rescue_from ActionController::ParameterMissing, with: :render_bad_request

    base.rescue_from Exceptions::Unauthorized, with: :render_unauthorized
    base.rescue_from Exceptions::TicketClosed, with: :render_bad_request
    base.rescue_from Exceptions::MissingAgents, with: :render_bad_request
    base.rescue_from JWT::VerificationError, with: :render_unauthorized
    base.rescue_from JWT::DecodeError, with: :render_unauthorized
    base.rescue_from Prawn::Errors::EmptyTable, with: :render_not_found
  end
end
