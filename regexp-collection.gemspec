# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path("../lib/regexp-collection/version", __FILE__)

Gem::Specification.new do |s|
  s.name                  = "regexp-collection"
  s.version               = Regexp::Collection::VERSION
  s.author                = "Yaroslav Konoplov"
  s.email                 = "eahome00@gmail.com"
  s.summary               = "Regular expression collection for Ruby."
  s.description           = "A gem providing pre-made and tested typical regular expressions for applications."
  s.homepage              = "https://github.com/yivo/regexp-collection"
  s.license               = "MIT"
  s.files                 = `git ls-files -z`.split("\x0")
  s.test_files            = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths         = ["lib"]
  s.add_development_dependency "bundler", "~> 1.7"
end
