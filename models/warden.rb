# frozen_string_literal: true
# https://github.com/simonneutert/sinatras-skeleton

class App < Sinatra::Base
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
      logger = Logger.new(STDOUT)
      
      if user.nil?
        logger.debug('Username does not exist.')
      elsif user.authenticate(params['user']['password'])
        logger.debug('User authenticated.')
        success!(user)
      else
        logger.debug('Username and password combination is wrong!')
      end
    end
  end
end