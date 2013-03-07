# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "biblicit"
  gem.version       = "2.0.4"
  gem.authors       = ["David Judd"]
  gem.email         = ["david@academia.edu"]
  gem.summary       = %q{Extract citations from PDFs.}
  gem.homepage      = "http://github.com/academia-edu/biblicit"

  gem.files         =
    `git ls-files`.split("\n") +
    `cd parscit && git ls-files`.split("\n").map{ |f| "parscit/#{f}" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'

  gem.requirements << 'For PDFs, Poppler or XPDF (try "which pdftotext")'
  gem.requirements << 'For Postscript files, Ghostscript (try "which ps2ascii")'
  gem.requirements << 'For word processor files, AbiWord (try "which abiword")'
  gem.requirements << 'For the :citeseer algorithm, Perl, CPAN, CRF++ (try "which crf_test"), and svm-light 5.0, aliased to svm_classify5 (try "svm_classify -h")'
  gem.requirements << 'For the :cb2bib algorithm, cb2Bib (try "which cb2bib")'

end
