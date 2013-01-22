# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "biblicit"
  gem.version       = "1.0"
  gem.authors       = ["David Judd"]
  gem.email         = ["david@academia.edu"]
  gem.description   = %q{Extract citations from PDFs.}
  gem.summary       = %q{Extract citations from PDFs.}
  gem.homepage      = "http://github.com/academia-edu/biblicit"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'

  gem.requirements << 'java'
  gem.requirements << 'perl'
  gem.requirements << 'for the :citeseer algorithm, the CRF++ Conditional Random Fields library (try "which crf_test")'
  gem.requirements << 'for the :cb2bib algorithm, the cb2bib citation extraction tool'

end
