# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "biblicit"
  gem.version       = "1.0"
  gem.authors       = ["David Judd", "CiteSeerX"]
  gem.email         = ["david@academia.edu"]
  gem.description   = %q{Wrapper around the core perl ingestion code from CiteSeerX}
  gem.summary       = %q{Wrapper around the core perl ingestion code from CiteSeerX}
  gem.homepage      = "http://github.com/academia-edu/biblicit"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'
end
