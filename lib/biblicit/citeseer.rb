# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module CiteSeer

  PERL_DIR = "#{File.dirname(__FILE__)}/../../parscit"
  SH_DIR = "#{File.dirname(__FILE__)}/../../sh"

  def self.extract(in_file, opts)
    ParseOperation.new(in_file)
  end

  class ParseOperation

    def initialize(in_file)
      ENV['CRFPP_HOME'] ||= '/usr/local'

      Dir.mktmpdir do |out_dir|
        `#{SH_DIR}/convert_to_text.sh #{in_file.shellescape} #{out_dir}/out.txt`
        output = `#{PERL_DIR}/bin/citeExtract.pl -q -m extract_all #{out_dir}/out.txt`
        @xml = Nokogiri::XML output
      end
    end

    def header
      @header ||= get_header
    end

    def citations
      @citations ||= get_citations
    end

  private

    def get_header
      ['ParsHed','SectLabel'].map do |algorithm|
        parsed = @xml.css("algorithm[name=#{algorithm}]")

        result = {
          title: parsed.css('title').text,
          authors: parsed.css('author').map(&:text),
          abstract: parsed.css('abstract').text,
          valid: true
        }

        [algorithm.downcase.to_sym, result]
      end.first.last
    end

    def get_citations
      # TODO
      []
    end

  end

end
