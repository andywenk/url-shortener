# frozen_string_literal: true

class User < ActiveRecord::Base
  include BCrypt
  validates :username, uniqueness: true
  validates :password, presence: true

  def authenticate(attempted_password)
    BCrypt::Password.new(password) == attempted_password
  end
end
