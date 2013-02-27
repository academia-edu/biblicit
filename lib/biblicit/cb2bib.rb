# encoding: UTF-8

require 'tempfile'

module Cb2Bib

  def self.extract(file, opts)
    ParseOperation.new(file, opts).result
  end

  class ParseOperation

    attr_reader :result

    def initialize(file, opts)
      extract_from_file(file, opts[:remote] || false, opts[:sloppy] || true)
    end

  private

    def extract_from_file(pdf, remote=false, sloppy=true)
      bib = Tempfile.new(['out','.bib'])
      conf = Tempfile.new(['cb2bib','.conf']) # we'll put our custom configuration here, and then cb2bib will fill in the rest with its defaults

      begin
        conf.write(cb2bib_config(remote))
        conf.open # not clear why we have to do this, but otherwise cb2bib doesn't read it
        `cb2bib #{sloppy ? '--sloppy' : ''} --doc2bib #{pdf.shellescape} #{bib.path} --conf #{conf.path}`
        bibtext = bib.read
      ensure
        conf.close!
        bib.close!
      end

      @result = {}

      if defined?(bibtext) && !bibtext.blank?
        bibtext.split("\n").each do |line|
          if (m = line.match /^(\w+)\s+= \{?(.+)\},?$/)
            field = cleaned_field(m[1])
            value = cleaned_value(field, m[2])
            @result[field] = value
          end
        end
      end

      @result[:valid] = !@result[:title].blank?
    end

    def cb2bib_config(remote)
      """
      [cb2Bib]
      AutomaticQuery=#{!!remote}

      [c2bPdfImport]
      Pdf2TextBin=#{File.dirname(__FILE__)}/../../sh/convert_to_text.sh
      Pdf2TextArg=
      """
    end

    def cleaned_field(field)
      cleaned = field.to_sym
      if cleaned == :author
        :authors
      else
        cleaned
      end
    end

    def cleaned_value(field, value)
      value.strip!
      if (m = value.match /^\{(.+)\}$/)
        value = m[1]
        value.strip!
      end

      if field == :authors
        value.split(' and ').map(&:strip)
      elsif value.match /^\d+$/
        value.to_i
      else
        value
      end
    end

  end

end
