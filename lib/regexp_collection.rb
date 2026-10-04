# frozen_string_literal: true

module Regexp::Collection
  module Number
    class << self
      attr_accessor :integer, :decimal, :natural_including_zero, :natural_excluding_zero, :hexadecimal

      def natural(zero = false)
        zero ? natural_including_zero : natural_excluding_zero
      end
    end

    # Matches integers without leading zeros (except single 0), e.g., -10, 0, 42
    self.integer = /\A(?:-?[1-9]\d*|0)\z/.freeze

    # Matches decimals: integers or numbers with a dot followed by digits.
    # Correctly supports negative decimals while rejecting -0 and -0.0
    self.decimal = /\A(?:-?[1-9]\d*(?:\.\d+)?|-0\.\d*[1-9]\d*|0(?:\.\d+)?)\z/.freeze

    # Matches natural numbers including 0
    self.natural_including_zero = /\A(?:0|[1-9]\d*)\z/.freeze

    # Matches natural numbers strictly greater than 0
    self.natural_excluding_zero = /\A[1-9]\d*\z/.freeze

    # Matches hexadecimal literals with 0x or 0X prefix (case-insensitive hex digits)
    self.hexadecimal = /\A0[xX][a-fA-F0-9]+\z/.freeze
  end

  module Time
    class << self
      attr_accessor :seconds_required, :seconds_not_permitted, :seconds_optional
    end

    # HH:MM:SS (hour 0-23, single digit permitted: 0-9)
    self.seconds_required = /\A(?:[01]?\d|2[0-3]):[0-5]\d:[0-5]\d\z/.freeze

    # HH:MM
    self.seconds_not_permitted = /\A(?:[01]?\d|2[0-3]):[0-5]\d\z/.freeze

    # HH:MM or HH:MM:SS
    self.seconds_optional = /\A(?:[01]?\d|2[0-3]):[0-5]\d(?::[0-5]\d)?\z/.freeze
  end

  module Crypto
    class << self
      attr_accessor \
        :trx_wallet_address_base58,
        :evm_wallet_address,
        :evm_transaction_hash,
        :tx_mainnet_wallet_address_bech32,
        :tx_testnet_wallet_address_bech32,
        :xrp_wallet_address_bech32
    end

    # Tron Base58Check address: starts with T, 34 chars total, excludes 0, O, I, l
    self.trx_wallet_address_base58 = /\AT[1-9A-HJ-NP-Za-km-z]{33}\z/.freeze

    # EVM address: 0x followed by exactly 40 hexadecimal characters
    self.evm_wallet_address = /\A0x[a-fA-F0-9]{40}\z/.freeze

    # EVM transaction hash: 0x followed by exactly 64 hexadecimal characters
    self.evm_transaction_hash = /\A0x[a-fA-F0-9]{64}\z/.freeze

    self.tx_mainnet_wallet_address_bech32 = /\Acore1[02-9ac-hj-np-z]{38}\z/.freeze

    self.tx_testnet_wallet_address_bech32 = /\Atestcore1[02-9ac-hj-np-z]{38}\z/.freeze

    # XRP Ledger uses a custom Base58 dictionary and starts with 'r', length 25-34 chars
    self.xrp_wallet_address_bech32 = /\Ar[rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz]{24,33}\z/.freeze
  end

  module UUID
    class << self
      attr_accessor :v4
    end

    # UUID version 4 strict validation (e.g., 123e4567-e89b-12d3-a456-426614174000)
    # 13th character must be '4', 17th character must be 8, 9, a, b, A, or B.
    self.v4 = /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/.freeze
  end
end
