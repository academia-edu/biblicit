# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module ParsCit

  PERL_DIR = "#{File.dirname(__FILE__)}/../../parscit"
  SH_DIR = "#{File.dirname(__FILE__)}/../../sh"

  def self.extract(in_file, opts={})
    ParseOperation.new(in_file, opts={}).results
  end

  class ParseOperation

    attr_reader :results

    def initialize(in_file, opts={})
      ENV['CRFPP_HOME'] ||= '/usr/local'

      token_flag = opts[:token] ? 't' : ''

      Dir.mktmpdir do |out_dir|
        `#{SH_DIR}/convert_to_text.sh #{in_file.shellescape} #{out_dir}/out.txt`

        output = `#{PERL_DIR}/bin/citeExtract.pl -q#{token_flag} -m extract_all #{out_dir}/out.txt`
        xml = Nokogiri::XML output
        @results = parse(xml)
      end
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
