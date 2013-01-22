# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module CiteSeer

  PERL_DIR = "#{File.dirname(__FILE__)}/../../perl"

  def self.extract(in_file)
    ParseOperation.new(in_file)
  end

  class ParseOperation

    def initialize(in_file)
      Dir.mktmpdir do |out_dir|
        `#{PERL_DIR}/extract.pl #{in_file.shellescape} #{out_dir}`
        @header_xml = IO.read("#{out_dir}/out.header")
        @citations_xml = IO.read("#{out_dir}/out.parscit")
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
      parsed = Nokogiri::XML @header_xml

      {
        title: parsed.css('title').text,
        authors: parsed.css('author > name').map { |n| n.text },
        abstract: parsed.css('abstract').text,
        valid: parsed.css('validHeader').first.text == '1',
      }
    end

    def get_citations
      # TODO
    end

  end

end
