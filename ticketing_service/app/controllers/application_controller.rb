#
# Application Controller
#
# @author [nityamvakil]
#
class ApplicationController < ActionController::API
  include Errors
  include ErrorHandlers
  include ActionController::MimeResponds

  before_filter :cors_preflight_check
  after_action :set_headers

  protected

  def authenticate_user!
    key = stored_key
    raise Exceptions::Unauthorized if key[:is_agent]
    @current_user = User.find key[:id]
  end

  def authenticate_agent!
    key = stored_key
    raise Exceptions::Unauthorized unless key[:is_agent]
    @current_user = Agent.find(key[:id])
  end

  def authenticate_admin!
    key = stored_key
    raise Exceptions::Unauthorized unless key[:is_admin]
    @current_user = Agent.find(key[:id])
  end

  private

  def stored_key
    token = request.headers['Authorization']
    JsonWebToken.decode(token).first.symbolize_keys
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With,
                                               Content-Type, Accept,
                                               Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT,
                                                 DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With,
                                                 X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render text: '', content_type: 'text/plain'
    end
  end

  def render_error(message, status, e)
    @trace = e.backtrace[0..15].map { |t| t }

    log_trace(e)
    render json: { errors: { message: message } }, status: status
  end

  def log_trace(e)
    Rails.logger.info "\n" \
    "============== EXCEPTION ============== \n" \
    "time: #{Time.zone.now} \n" \
    "exception: #{e.class} \n" \
    "message: #{e.message} \n" \
    "-------------- backtrace --------------  \n" \
    "#{@trace.join("\n")} \n" \
    "=======================================  \n"
  end
end
