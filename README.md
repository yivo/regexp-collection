# regexp-collection

A gem providing pre-made and tested typical regular expressions for Ruby applications

## Requirements

* Ruby >= 2.7.0

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "regexp-collection", "~> 2.0"
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install regexp-collection
```

## Usage

The library is divided into logical modules. All regular expressions are frozen (`.freeze`) for safe and optimal use as constants

### Numbers (`Regexp::Collection::Number`)

Strict validation for numeric formats, preventing injections and incorrect structures (like leading zeros or `-0`)

```ruby
require "regexp_collection"

# Matches integers (-10, 0, 42). Rejects leading zeros and "-0".
"-42".match?(Regexp::Collection::Number.integer) # => true
"-0".match?(Regexp::Collection::Number.integer)  # => false

# Matches decimals (-0.5, 0.0, 12.34). Rejects "-0.0".
"12.34".match?(Regexp::Collection::Number.decimal) # => true

# Matches natural numbers
"0".match?(Regexp::Collection::Number.natural(true))  # => true (including zero)
"0".match?(Regexp::Collection::Number.natural(false)) # => false (excluding zero)
"42".match?(Regexp::Collection::Number.natural_excluding_zero) # => true

# Matches hexadecimal strings (0x or 0X prefix)
"0x1a2B3c".match?(Regexp::Collection::Number.hexadecimal) # => true
```

### Time (`Regexp::Collection::Time`)

Validation for 24-hour time formats

```ruby
# HH:MM:SS format
"23:59:59".match?(Regexp::Collection::Time.seconds_required) # => true
"23:59".match?(Regexp::Collection::Time.seconds_required)    # => false

# HH:MM format
"23:59".match?(Regexp::Collection::Time.seconds_not_permitted) # => true

# HH:MM or HH:MM:SS format
"23:59".match?(Regexp::Collection::Time.seconds_optional)    # => true
"23:59:59".match?(Regexp::Collection::Time.seconds_optional) # => true
```

### Crypto (`Regexp::Collection::Crypto`)

Validation for various blockchain wallet addresses and transaction hashes

```ruby
# EVM (Ethereum, BSC, Polygon, etc.)
"0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045".match?(Regexp::Collection::Crypto.evm_wallet_address) # => true
"0x5c504ed432cb51138b309d43e110f94f6470077cbe40191498b82a8763046ad1".match?(Regexp::Collection::Crypto.evm_transaction_hash) # => true

# TRON (Base58Check)
"TNDzfERD73nNqaTTrvNX7moW2GFp3W5amz".match?(Regexp::Collection::Crypto.trx_wallet_address_base58) # => true

# TX (Bech32)
"core1023456789acdefghjklmnpqrstuvwxyz023456".match?(Regexp::Collection::Crypto.tx_mainnet_wallet_address_bech32) # => true
"testcore1023456789acdefghjklmnpqrstuvwxyz023456".match?(Regexp::Collection::Crypto.tx_testnet_wallet_address_bech32) # => true

# XRP Ledger (Custom Base58)
"rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn".match?(Regexp::Collection::Crypto.xrp_wallet_address_bech32) # => true
```

### UUID (`Regexp::Collection::UUID`)

Strict validation for UUID identifiers

```ruby
# Strict UUID v4 validation
"123e4567-e89b-42d3-a456-426614174000".match?(Regexp::Collection::UUID.v4) # => true
```

## Development and Testing

To run the test suite

```bash
$ rake test
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT)
