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
      parse_modes = if (opts.fetch :include_citations, false)
                      { extract_all: [:citeseer, :parshed, :citations] }
                    else
                      {
                        extract_header_svm_only: [:citeseer],
                        extract_header_crf_only: [:parshed]
                      }
                    end

      ENV['SVM_LIGHT_HOME'] ||= "#{File.dirname(`which svm_classify`)}"
      ENV['CRFPP_HOME'] ||= "#{File.dirname(`which crf_test`)}/../"
      ENV['PARSCIT_TMPDIR'] ||= Dir.tmpdir

      @result = {}

      parse_modes.map do |mode, keys|
        outf = Tempfile.new mode.to_s
        pid = spawn("#{PERL_DIR}/bin/citeExtract.pl -q -m #{mode} #{in_txt.path}", out: outf.path)
        [pid, outf, keys]
      end.each do |pid, outf, keys|
        Process.wait pid
        output = File.read outf
        outf.unlink
        @result.merge! parse(Nokogiri::XML output).slice(*keys)
      end
    end

  private

    def parse(xml)
      result = {}

      parshed = xml.css("algorithm[name=ParsHed]")
      result[:parshed] = {
        title: parshed.css('title').text.gsub(/\s+/,' ').strip,
        authors: parshed.css('author').map { |a| a.text.gsub(/\s+/,' ').strip },
        abstract: parshed.css('abstract').text#,
        #confidence: parshed.css('title').attr('confidence').value.to_f
      }

      svm = xml.css('algorithm[name="SVM HeaderParse"]')
      result[:citeseer] = {
        title: svm.css('title').text,
        authors: svm.css('author > name').map { |n| n.text.strip }.reject(&:blank?).uniq,
        author_emails: svm.css('author > email').map { |n| n.text.strip }.reject(&:blank?).uniq,
        abstract: svm.css('abstract').text,
        valid: svm.css('validHeader').first.try(:text) == '1'
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
