# encoding UTF-8

require 'tempfile'

module Cb2Bib

  CB2BIB_CONFIG_PATH = "#{File.dirname(__FILE__)}/../../resources/cb2Bib.conf"
  CB2BIB_CONFIG = IO.read(CB2BIB_CONFIG_PATH)

  def self.extract(content, sloppy=true)
    ParseOperation.new(content, sloppy)
  end

  class ParseOperation

    def initialize(content, sloppy=true)
      pdf = Tempfile.new('pdf')
      bib = Tempfile.new('bib')
      conf = Tempfile.new('conf') # we'll put our custom configuration here, and then cb2bib will fill in the rest with its defaults

      begin
        pdf.write(content)
        conf.write(CB2BIB_CONFIG)
        conf.open # not clear why we have to do this, but otherwise cb2bib doesn't read it
        `cb2bib #{sloppy ? '--sloppy' : ''} --doc2bib #{pdf.path} #{bib.path} --conf #{conf.path}`
        bibtext = bib.read
      ensure
        pdf.close!
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
    end

    def header
      @result
    end

  private

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
