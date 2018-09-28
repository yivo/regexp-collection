# encoding: UTF-8
# frozen_string_literal: true

module Regexp::Collection
  module Numbers
    class << self
      attr_accessor :integer, :decimal, :natural_including_zero, :natural_excluding_zero

      def natural(zero = false)
        zero ? natural_including_zero : natural_excluding_zero
      end
    end

    self.integer                = /\A(?:-?[1-9]\d*\z)|(?:\A0)\z/.freeze
    self.decimal                = /\A(?:-?[1-9]\d*(?:\.\d+)?\z)|(?:\A0(?:\.\d+)?)\z/.freeze
    self.natural_including_zero = /\A(?:0\z)|(?:\A[1-9]\d*)\z/.freeze
    self.natural_excluding_zero = /\A[1-9]\d*\z/.freeze
  end
end
