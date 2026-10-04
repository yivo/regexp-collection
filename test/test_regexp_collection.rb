# frozen_string_literal: true

require_relative "test_helper"

class RegexpCollectionTest < Test::Unit::TestCase
  test "Version constant" do
    assert_not_nil Regexp::Collection::VERSION
    assert_true Regexp::Collection::VERSION.match?(/\A\d+\.\d+\.\d+\z/)
  end

  test "Number.integer" do
    regexp = Regexp::Collection::Number.integer

    # Valid
    assert_true "0".match?(regexp)
    assert_true "1".match?(regexp)
    assert_true "2".match?(regexp)
    assert_true "-1".match?(regexp)
    assert_true "10".match?(regexp)
    assert_true "100".match?(regexp)
    assert_true "1000".match?(regexp)
    assert_true "9999".match?(regexp)
    assert_true "-9999".match?(regexp)
    assert_true "9000000".match?(regexp)

    # Invalid - zero variations
    assert_false "-0".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "00".match?(regexp)
    assert_false "-00".match?(regexp)
    assert_false "+00".match?(regexp)

    # Invalid - leading plus and leading zeros
    assert_false "+1".match?(regexp)
    assert_false "+42".match?(regexp)
    assert_false "01".match?(regexp)
    assert_false "-01".match?(regexp)

    # Invalid - characters and formatting
    assert_false "".match?(regexp)
    assert_false " ".match?(regexp)
    assert_false "-".match?(regexp)
    assert_false "1xx".match?(regexp)
    assert_false "xx1".match?(regexp)
    assert_false "-x1".match?(regexp)
    assert_false "-1x".match?(regexp)
    assert_false "1,000".match?(regexp)
    assert_false "1.0".match?(regexp)

    # Edge cases - multiline injection checks (\A and \z)
    assert_false "1\n".match?(regexp)
    assert_false "\n1".match?(regexp)
    assert_false "1\n2".match?(regexp)
  end

  test "Number.decimal" do
    regexp = Regexp::Collection::Number.decimal

    # Valid - integers
    assert_true "0".match?(regexp)
    assert_true "1".match?(regexp)
    assert_true "-1".match?(regexp)
    assert_true "100".match?(regexp)

    # Valid - standard decimals
    assert_true "0.0".match?(regexp)
    assert_true "0.5".match?(regexp)
    assert_true "0.12345".match?(regexp)
    assert_true "1.0".match?(regexp)
    assert_true "-1.0".match?(regexp)
    assert_true "12.34".match?(regexp)
    assert_true "-12.34".match?(regexp)

    # Valid - negative fractions strictly less than 0
    assert_true "-0.5".match?(regexp)
    assert_true "-0.01".match?(regexp)
    assert_true "-0.00001".match?(regexp)

    # Invalid - zero forms
    assert_false "-0".match?(regexp)
    assert_false "+0".match?(regexp)
    assert_false "-0.0".match?(regexp)
    assert_false "-0.00".match?(regexp)
    assert_false "+0.0".match?(regexp)
    assert_false "+00.0".match?(regexp)

    # Invalid - leading plus and leading zeros
    assert_false "+1".match?(regexp)
    assert_false "+1.0".match?(regexp)
    assert_false "+0.5".match?(regexp)
    assert_false "01".match?(regexp)
    assert_false "01.5".match?(regexp)

    # Invalid - structure
    assert_false ".".match?(regexp)
    assert_false ".5".match?(regexp)
    assert_false "-.5".match?(regexp)
    assert_false "1.".match?(regexp)
    assert_false "1.2.3".match?(regexp)
    assert_false "-1.5x".match?(regexp)
    assert_false "1e5".match?(regexp)
    assert_false "".match?(regexp)

    # Edge cases - multiline injection checks
    assert_false "1.5\n".match?(regexp)
    assert_false "\n1.5".match?(regexp)
  end

  test "Number.natural" do
    # Default argument must equal natural(false)
    assert_equal Regexp::Collection::Number.natural(false), Regexp::Collection::Number.natural

    # natural(true) - including zero
    reg_with_zero = Regexp::Collection::Number.natural(true)
    assert_true "0".match?(reg_with_zero)
    assert_true "1".match?(reg_with_zero)
    assert_true "16".match?(reg_with_zero)
    assert_true "999999".match?(reg_with_zero)
    assert_false "-0".match?(reg_with_zero)
    assert_false "+0".match?(reg_with_zero)
    assert_false "00".match?(reg_with_zero)
    assert_false "-1".match?(reg_with_zero)
    assert_false "+1".match?(reg_with_zero)
    assert_false "0.0".match?(reg_with_zero)
    assert_false "1.0".match?(reg_with_zero)
    assert_false "0foo".match?(reg_with_zero)
    assert_false "0\n".match?(reg_with_zero)

    # natural(false) - excluding zero
    reg_without_zero = Regexp::Collection::Number.natural(false)
    assert_false "0".match?(reg_without_zero)
    assert_true "1".match?(reg_without_zero)
    assert_true "16".match?(reg_without_zero)
    assert_false "-1".match?(reg_without_zero)
    assert_false "+1".match?(reg_without_zero)
    assert_false "01".match?(reg_without_zero)
    assert_false "".match?(reg_without_zero)
  end

  test "Number.hexadecimal" do
    regexp = Regexp::Collection::Number.hexadecimal

    # Valid
    assert_true "0x0".match?(regexp)
    assert_true "0x1".match?(regexp)
    assert_true "0xabcdef".match?(regexp)
    assert_true "0xABCDEF".match?(regexp)
    assert_true "0x1a2B3c".match?(regexp)
    assert_true "0X1a2b".match?(regexp)
    assert_true "0XDEADBEEF".match?(regexp)

    # Invalid
    assert_false "".match?(regexp)
    assert_false "0x".match?(regexp)
    assert_false "0X".match?(regexp)
    assert_false "abcdef".match?(regexp)
    assert_false "x12".match?(regexp)
    assert_false "0x12g".match?(regexp)
    assert_false "0x12Z".match?(regexp)
    assert_false "-0x12".match?(regexp)
    assert_false " 0x12".match?(regexp)
    assert_false "0x12\n".match?(regexp)
  end

  test "Time.seconds_required" do
    regexp = Regexp::Collection::Time.seconds_required

    # Valid
    assert_true "00:00:00".match?(regexp)
    assert_true "01:00:00".match?(regexp)
    assert_true "1:00:00".match?(regexp)
    assert_true "12:11:10".match?(regexp)
    assert_true "12:10:09".match?(regexp)
    assert_true "23:59:59".match?(regexp)

    # Invalid - missing or excess parts
    assert_false "".match?(regexp)
    assert_false "12".match?(regexp)
    assert_false "12:11".match?(regexp)
    assert_false "12:11:".match?(regexp)
    assert_false ":12:11:10".match?(regexp)
    assert_false "12:0:0".match?(regexp)
    assert_false "12:10:09.111".match?(regexp)

    # Invalid - boundaries
    assert_false "24:00:00".match?(regexp)
    assert_false "25:00:00".match?(regexp)
    assert_false "12:60:00".match?(regexp)
    assert_false "12:11:60".match?(regexp)

    # Edge cases
    assert_false "+12:11:10".match?(regexp)
    assert_false "12:11:10foo".match?(regexp)
    assert_false "12:11:10\n".match?(regexp)
  end

  test "Time.seconds_optional" do
    regexp = Regexp::Collection::Time.seconds_optional

    # Valid
    assert_true "00:00".match?(regexp)
    assert_true "00:00:00".match?(regexp)
    assert_true "1:00".match?(regexp)
    assert_true "1:00:00".match?(regexp)
    assert_true "12:11".match?(regexp)
    assert_true "12:11:10".match?(regexp)
    assert_true "23:59".match?(regexp)
    assert_true "23:59:59".match?(regexp)

    # Invalid
    assert_false "".match?(regexp)
    assert_false "12".match?(regexp)
    assert_false "12:".match?(regexp)
    assert_false "12:11:".match?(regexp)
    assert_false "24:00".match?(regexp)
    assert_false "24:00:00".match?(regexp)
    assert_false "12:60".match?(regexp)
    assert_false "12:11:60".match?(regexp)
    assert_false "12:11:10\n".match?(regexp)
  end

  test "Time.seconds_not_permitted" do
    regexp = Regexp::Collection::Time.seconds_not_permitted

    # Valid
    assert_true "00:00".match?(regexp)
    assert_true "01:00".match?(regexp)
    assert_true "1:00".match?(regexp)
    assert_true "12:11".match?(regexp)
    assert_true "23:59".match?(regexp)

    # Invalid
    assert_false "".match?(regexp)
    assert_false "12:11:10".match?(regexp)
    assert_false "01:00:00".match?(regexp)
    assert_false "24:00".match?(regexp)
    assert_false "12:60".match?(regexp)
    assert_false "12:11\n".match?(regexp)
  end

  test "Crypto.trx_wallet_address_base58" do
    regexp = Regexp::Collection::Crypto.trx_wallet_address_base58

    # Valid TRON Base58 addresses (starts with T, 34 chars)
    assert_true "TNDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_true "TN3W4H6rK2ce4vX9YnFQHwKENnHjoxb3m9".match?(regexp)
    assert_true "TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH".match?(regexp)

    # Invalid - wrong prefix
    assert_false "ANDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_false "41DzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)

    # Invalid - incorrect length
    assert_false "TNDzfERD73nNqaTTrvNX7moW2GFp3W5am".match?(regexp)  # 33 chars
    assert_false "TNDzfERD73nNqaTTrvNX7moW2GFp3W5amzz".match?(regexp) # 35 chars

    # Invalid - non-Base58 characters (0, O, I, l)
    assert_false "T0DzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_false "TODzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_false "TIDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_false "TlDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)

    # Invalid - spaces and newlines
    assert_false " TNDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(regexp)
    assert_false "TNDzfERD73nNqaTTrvNX7moW2GFp3W5amz\n".match?(regexp)
    assert_false "".match?(regexp)
  end

  test "Crypto.evm_wallet_address" do
    regexp = Regexp::Collection::Crypto.evm_wallet_address

    # Valid (40 hex chars after 0x)
    assert_true "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045".match?(regexp)
    assert_true "0x0000000000000000000000000000000000000000".match?(regexp)
    assert_true "0xffffffffffffffffffffffffffffffffffffffff".match?(regexp)
    assert_true "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF".match?(regexp)

    # Invalid - non-hex characters (g-z, G-Z)
    assert_false "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA9604G".match?(regexp)
    assert_false "0xZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ".match?(regexp)

    # Invalid - missing prefix
    assert_false "d8dA6BF26964aF9D7eEd9e03E53415D37aA96045".match?(regexp)

    # Invalid - incorrect length
    assert_false "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA9604".match?(regexp)   # 39 chars
    assert_false "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA960455".match?(regexp) # 41 chars

    # Invalid - spaces and newlines
    assert_false " 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045".match?(regexp)
    assert_false "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045\n".match?(regexp)
    assert_false "".match?(regexp)
  end

  test "Crypto.evm_transaction_hash" do
    regexp = Regexp::Collection::Crypto.evm_transaction_hash

    # Valid (64 hex chars after 0x)
    assert_true "0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad1".match?(regexp)
    assert_true "0x5C504ED432CB51138B309D43E110F94F6470077CBE40191498B82A8763046AD1".match?(regexp)
    assert_true "0x0000000000000000000000000000000000000000000000000000000000000000".match?(regexp)

    # Invalid - non-hex characters
    assert_false "0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046adG".match?(regexp)

    # Invalid - missing prefix
    assert_false "5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad1".match?(regexp)

    # Invalid - length
    assert_false "0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad".match?(regexp)   # 63 chars
    assert_false "0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad11".match?(regexp) # 65 chars

    # Invalid - spaces and newlines
    assert_false "0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad1\n".match?(regexp)
    assert_false "".match?(regexp)
  end

  test "Crypto.tx_mainnet_wallet_address_bech32" do
    regexp = Regexp::Collection::Crypto.tx_mainnet_wallet_address_bech32

    # Valid addresses (starts with core1, 38 bech32 chars)
    assert_true "core1023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_true "core1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq".match?(regexp)

    # Invalid - wrong prefix
    assert_false "testcore1023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core2023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)

    # Invalid - non-bech32 characters (1, b, i, o, uppercase letters)
    assert_false "core1b23456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core1i23456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core1o23456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core1123456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core1023456789ACDEFGHJKLMNPQRSTUVWXYZ023456".match?(regexp)

    # Invalid - incorrect length
    assert_false "core1023456789acdefghjklmnpqrstuvwxyz02345".match?(regexp)   # 37 chars
    assert_false "core1023456789acdefghjklmnpqrstuvwxyz0234567".match?(regexp) # 39 chars

    # Invalid - spaces and newlines
    assert_false " core1023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "core1023456789acdefghjklmnpqrstuvwxyz023456\n".match?(regexp)
    assert_false "".match?(regexp)
  end

  test "Crypto.tx_testnet_wallet_address_bech32" do
    regexp = Regexp::Collection::Crypto.tx_testnet_wallet_address_bech32

    # Valid addresses (starts with testcore1, 38 bech32 chars)
    assert_true "testcore1023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_true "testcore1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq".match?(regexp)

    # Invalid - wrong prefix
    assert_false "core1023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)
    assert_false "testcore2023456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)

    # Invalid - non-bech32 characters (1, b, i, o)
    assert_false "testcore1b23456789acdefghjklmnpqrstuvwxyz023456".match?(regexp)

    # Invalid - incorrect length
    assert_false "testcore1023456789acdefghjklmnpqrstuvwxyz02345".match?(regexp)   # 37 chars
    assert_false "testcore1023456789acdefghjklmnpqrstuvwxyz0234567".match?(regexp) # 39 chars
  end

  test "UUID.v4" do
    regexp = Regexp::Collection::UUID.v4

    assert_true "123e4567-e89b-42d3-a456-426614174000".match?(regexp) # Valid v4
    assert_true "123E4567-E89B-42D3-A456-426614174000".match?(regexp) # Valid v4 uppercase

    assert_false "123e4567-e89b-12d3-a456-426614174000".match?(regexp) # Invalid (v1, missing '4')
    assert_false "123e4567-e89b-42d3-c456-426614174000".match?(regexp) # Invalid (17th char is 'c')
    assert_false "123e4567-e89b-42d3-a456-426614174000\n".match?(regexp)
  end

  test "Crypto.xrp_wallet_address_bech32" do
    regexp = Regexp::Collection::Crypto.xrp_wallet_address_bech32

    assert_true "rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn".match?(regexp)

    assert_false "RG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn".match?(regexp) # Doesn't start with lowercase 'r'
    assert_false "rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCl".match?(regexp) # Contains 'l' (not in XRP dictionary)
  end
end
