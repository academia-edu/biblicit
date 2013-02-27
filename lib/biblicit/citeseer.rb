# encoding: UTF-8

require 'tmpdir'
require 'shellwords'
require 'nokogiri'

module CiteSeer

  PERL_DIR = "#{File.dirname(__FILE__)}/../../svm-header-parse"
  SH_DIR = "#{File.dirname(__FILE__)}/../../sh"

  def self.extract(in_file, opts={})
    ParseOperation.new(in_file).result
  end

  class ParseOperation

    attr_reader :result

    def initialize(in_file)
      Dir.mktmpdir do |out_dir|
        `#{SH_DIR}/convert_to_text.sh #{in_file.shellescape} #{out_dir}/out.txt`
        `#{PERL_DIR}/extract.pl #{out_dir}/out.txt #{out_dir}`
        output = IO.read("#{out_dir}/out.header")
        xml = Nokogiri::XML output
        @result = parse(xml)
      end
    end

  private

    def parse(xml)
      {
        title: xml.css('title').text,
        authors: xml.css('author > name').map { |n| n.text },
        abstract: xml.css('abstract').text,
        valid: xml.css('validHeader').first.text == '1',
      }
    end

  end

end
