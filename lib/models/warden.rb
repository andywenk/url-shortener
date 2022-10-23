# frozen_string_literal: true
# https://github.com/simonneutert/sinatras-skeleton

class App < Sinatra::Application
  use Warden::Manager do |config|
    config.serialize_into_session(&:id)
    config.serialize_from_session { |id| User.find(id) }
    config.scope_defaults :default,
                          strategies: [:password],
                          action: 'auth/unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env, _opts|
    env['REQUEST_METHOD'] = 'POST'
    env.each do |key, _value|
      env[key]['_method'] = String.new('post') if key == 'rack.request.form_hash'
    end
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.find_by(username: params['user']['username'])

      if user.nil?
        throw(:warden, message: 'The username you entered does not exist.')
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        throw(:warden, message: 'The username and password combination ')
      end
    end
  end
end