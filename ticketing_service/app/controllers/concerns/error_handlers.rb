#
# Error handlers for vendor portal
#
# @author [nityamvakil]
#
module ErrorHandlers
  extend ActiveSupport::Concern

  def render_not_found(e)
    render_error(e.message, 404, e)
  end

  def render_bad_request(e)
    render_error(e.message, 400, e)
  end

  def render_unauthorized(e)
    render_error(e.message, 401, e)
  end

  def render_forbidden(e)
    render_error(e.message, 403, e)
  end

  def render_gateway_timeout(e)
    render_error('Gateway Timeout!', 504, e)
  end

  def render_server_error(e)
    render_error('Something went wrong!', 500, e)
  end
end
