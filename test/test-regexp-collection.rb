# encoding: UTF-8
# frozen_string_literal: true

require_relative "helper"

class RegexpCollectionTest < Test::Unit::TestCase
  test "Numbers.integer" do
    regexp = Regexp::Collection::Numbers.integer
    assert_true "1".match?(regexp)
    assert_true "2".match?(regexp)
    assert_false "01".match?(regexp)
    assert_false "-0".match?(regexp)
    assert_false "-00".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "+00".match?(regexp)
    assert_false "+1".match?(regexp)
    assert_true "-1".match?(regexp)
    assert_true "10".match?(regexp)
    assert_false "1xx".match?(regexp)
    assert_false "xx1".match?(regexp)
    assert_false "-x1".match?(regexp)
    assert_false "-1x".match?(regexp)
    assert_true "10".match?(regexp)
    assert_true "100".match?(regexp)
    assert_true "1000".match?(regexp)
    assert_true "9999".match?(regexp)
    assert_true "9000000".match?(regexp)
    assert_false "00".match?(regexp)
    assert_false " ".match?(regexp)
  end

  test "Numbers.decimal" do
    regexp = Regexp::Collection::Numbers.decimal
    assert_true "1".match?(regexp)
    assert_true "2".match?(regexp)
    assert_false "01".match?(regexp)
    assert_false "-0".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "+1".match?(regexp)
    assert_true "-1".match?(regexp)
    assert_true "10".match?(regexp)
    assert_false "1xx".match?(regexp)
    assert_false "xx1".match?(regexp)
    assert_false "-x1".match?(regexp)
    assert_false "-1x".match?(regexp)
    assert_false "-1.5x".match?(regexp)
    assert_true "10".match?(regexp)
    assert_true "100".match?(regexp)
    assert_true "1000".match?(regexp)
    assert_true "9999".match?(regexp)
    assert_true "9000000".match?(regexp)
    assert_false "-0.0".match?(regexp)
    assert_false "+0.0".match?(regexp)
    assert_false "+1.0".match?(regexp)
    assert_true "-1.0".match?(regexp)
    assert_true "0.0".match?(regexp)
    assert_false "+00.0".match?(regexp)
  end

  test "Numbers.natural(true)" do
    regexp = Regexp::Collection::Numbers.natural(true)
    assert_true "0".match?(regexp)
    assert_false "-0".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "0.0".match?(regexp)
    assert_false "-0.0".match?(regexp)
    assert_false "+0.0".match?(regexp)
    assert_false "00".match?(regexp)
    assert_true "1".match?(regexp)
    assert_false "-1".match?(regexp)
    assert_false "+1".match?(regexp)
    assert_false "1.0".match?(regexp)
    assert_false "-1.0".match?(regexp)
    assert_false "+1.0".match?(regexp)
    assert_false "1.1".match?(regexp)
    assert_false "-1.1".match?(regexp)
    assert_false "+1.1".match?(regexp)
    assert_false "foo".match?(regexp)
    assert_false "0foo".match?(regexp)
    assert_false "-0foo".match?(regexp)
    assert_false "+0foo".match?(regexp)
    assert_false "1foo".match?(regexp)
    assert_false "-1foo".match?(regexp)
    assert_false "+1foo".match?(regexp)
    assert_true "16".match?(regexp)
  end

  test "Numbers.natural(false)" do
    regexp = Regexp::Collection::Numbers.natural(false)
    assert_false "0".match?(regexp)
    assert_false "-0".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "0.0".match?(regexp)
    assert_false "-0.0".match?(regexp)
    assert_false "+0.0".match?(regexp)
    assert_false "00".match?(regexp)
    assert_true "1".match?(regexp)
    assert_false "-1".match?(regexp)
    assert_false "+1".match?(regexp)
    assert_false "1.0".match?(regexp)
    assert_false "-1.0".match?(regexp)
    assert_false "+1.0".match?(regexp)
    assert_false "1.1".match?(regexp)
    assert_false "-1.1".match?(regexp)
    assert_false "+1.1".match?(regexp)
    assert_false "foo".match?(regexp)
    assert_false "0foo".match?(regexp)
    assert_false "-0foo".match?(regexp)
    assert_false "+0foo".match?(regexp)
    assert_false "1foo".match?(regexp)
    assert_false "-1foo".match?(regexp)
    assert_false "+1foo".match?(regexp)
    assert_true "16".match?(regexp)
  end
end