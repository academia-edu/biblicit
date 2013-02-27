# encoding: UTF-8

require 'biblicit/cb2bib'
require 'biblicit/citeseer'
require 'biblicit/parscit'

require 'tempfile'

module Biblicit

  SH_DIR = "#{File.dirname(__FILE__)}/../../sh"

  module Extractor

    def self.extract(opts)
      if (content = opts.delete(:content))
        Tempfile.open('in') do |in_file|
          in_file.binmode
          in_file.write(content)
          extract_from_file in_file.path, opts
        end
      elsif (file = opts.delete(:file))
        extract_from_file file, opts
      else
        raise 'Either file or content is required'
      end
    end

  private

    def self.extract_from_file(file, opts)
      file = File.realpath(file)
      tools = opts.delete(:tools) || [:parshed, :sectlabel, :citeseer]

      result = {}

      Tempfile.open(['in','.txt']) do |in_txt|
        `#{SH_DIR}/convert_to_text.sh #{file.shellescape} #{in_txt.path}`

        if !(tools & [:parshed, :sectlabel]).empty?
          result.merge! ParsCit.extract(in_txt, opts)
        end

        if tools.include?(:citeseer)
          result.merge!( citeseer: CiteSeer.extract(in_txt, opts) )
        end

        if tools.include?(:cb2bib)
          result.merge!( cb2bib: Cb2Bib.extract(in_txt, opts) )
        end
      end

      result
    end

  end

end
