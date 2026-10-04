# frozen_string_literal: true

require_relative "lib/regexp_collection/version"

Gem::Specification.new do |s|
  s.name                  = "regexp-collection"
  s.version               = Regexp::Collection::VERSION
  s.authors               = ["Yaroslav Konoplov"]
  s.email                 = ["eahome00@gmail.com"]
  s.summary               = "Regular expression collection for Ruby"
  s.description           = "A gem providing pre-made and tested typical regular expressions for applications"
  s.homepage              = "https://github.com/yivo/regexp-collection"
  s.license               = "MIT"

  s.required_ruby_version = [">= 2.7.0", "< 5.0"]

  s.files                 = Dir.chdir File.expand_path(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  s.require_paths         = ["lib"]

  s.add_development_dependency "rake", "~> 13.4"
  s.add_development_dependency "test-unit", "~> 3.7"
end
