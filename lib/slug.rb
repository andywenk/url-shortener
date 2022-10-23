# frozen_string_literal: true

class Slug
  attr_reader :slug_length

  def initialize
    @slug_length = 5

  end

  def make
    Array.new(slug_length){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end
end