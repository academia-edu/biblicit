# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module ParsCit

  PERL_DIR = "#{File.dirname(__FILE__)}/../../parscit"

  def self.extract(in_file, opts={})
    ParseOperation.new(in_file, opts).result
  end

  class ParseOperation

    attr_reader :result

    def initialize(in_txt, opts={})
      ENV['CRFPP_HOME'] ||= "#{File.dirname(`which crf_test`)}/../"
      output = `#{PERL_DIR}/bin/citeExtract.pl -q -m extract_all #{in_txt.path}`
      @result = parse(Nokogiri::XML output)
    end

  private

    def parse(xml)
      parsed = xml.css("algorithm[name=ParsHed]")
      {
        title: parsed.css('title').text.gsub(/\s+/,' ').strip,
        authors: parsed.css('author').map { |a| a.text.gsub(/\s+/,' ').strip },
        abstract: parsed.css('abstract').text
      }
    end

  end

end
