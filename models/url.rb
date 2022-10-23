# frozen_string_literal: true

class Url < ActiveRecord::Base
  validates :source, uniqueness: true
end