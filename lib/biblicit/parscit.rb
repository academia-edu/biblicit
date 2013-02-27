# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module ParsCit

  PERL_DIR = "#{File.dirname(__FILE__)}/../../parscit"

  def self.extract(in_file, opts={})
    ParseOperation.new(in_file, opts).results
  end

  class ParseOperation

    attr_reader :results

    def initialize(in_txt, opts={})
      ENV['CRFPP_HOME'] ||= "#{File.dirname(`which crf_test`)}/../"
      token_flag = opts[:token] ? 't' : ''
      output = `#{PERL_DIR}/bin/citeExtract.pl -q#{token_flag} -m extract_all #{in_txt.path}`
      @results = parse(Nokogiri::XML output)
    end

  private

    def parse(xml)
      ['ParsHed','SectLabel'].inject({}) do |results, algorithm|
        parsed = xml.css("algorithm[name=#{algorithm}]")

        result = {
          title: parsed.css('title').text.gsub(/\s+/,' ').strip,
          authors: parsed.css('author').map { |a| a.text.gsub(/\s+/,' ').strip },
          abstract: parsed.css('abstract').text
        }

        results[algorithm.downcase.to_sym] = result
        results
      end
    end

  end

end
