# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path("../lib/regexp-collection/version", __FILE__)

Gem::Specification.new do |s|
  s.name                  = "regexp-collection"
  s.version               = Regexp::Collection::VERSION
  s.author                = "Yaroslav Konoplov"
  s.email                 = "eahome00@gmail.com"
  s.summary               = "Regular expression collection library for Ruby."
  s.description           = "Regular expression collection library for Ruby."
  s.homepage              = "https://github.com/yivo/regexp-collection"
  s.license               = "Apache-2.0"
  s.files                 = `git ls-files -z`.split("\x0")
  s.test_files            = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths         = ["lib"]
  s.required_ruby_version = "~> 2.5"
  s.add_development_dependency "bundler", "~> 1.7"
end
