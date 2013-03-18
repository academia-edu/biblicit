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

      result = {
        title: parsed.css('title').text.gsub(/\s+/,' ').strip,
        authors: parsed.css('author').map { |a| a.text.gsub(/\s+/,' ').strip },
        abstract: parsed.css('abstract').text
      }

      citations = xml.css('algorithm[name=ParsCit] > citationList > citation').map do |node|
        cite = {
          authors: node.css('author').map(&:text).map(&:strip).reject(&:blank?).uniq
        }

        node.children.each do |child|
          unless ['contexts','authors','marker','rawString'].include?(child.name) || (text = child.text.strip).blank?
            cite[child.name.to_sym] = text
          end
        end

        cite
      end

      result[:citations] = citations
      result
    end

  end

end
