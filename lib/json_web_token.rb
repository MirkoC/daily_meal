class JsonWebToken
  def self.encode(payload)
    payload[:exp] = Time.now.to_i + 336 * 3600
    JWT.encode(payload, 'secret')
    # JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, 'secret')[0])
    # return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
  rescue
    nil
  end
end
