module JwtAuth
  extend ActiveSupport::Concern

  def authenticate_request!
    if email_in_token?
      @current_user = User.find_by_email(auth_token[:email])
      return true if @current_user
    end
    incorrect_jwt_response
  rescue JWT::VerificationError, JWT::DecodeError
    incorrect_jwt_response
  end

  private

  def incorrect_jwt_response
    response_error = { title: 'Not Authenticated',
                       bearer: ['Missing or incorrect authorization header'] }
    render json: { errors: response_error }, status: :unauthorized
  end

  def http_token
    return unless request.headers['Authorization'].present?
    authorization = request.headers['Authorization'].split(' ')
    return unless authorization.first == 'Bearer'
    @http_token ||= request.headers['Authorization'].split(' ').last
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def email_in_token?
    http_token && auth_token && auth_token[:email]
  end
end
