# encoding: UTF-8

require 'biblicit/cb2bib'
require 'biblicit/citeseer'

require 'tempfile'

module Biblicit

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
    default_citeseer_algorithms = [:parshed, :sectlabel]
    tools = opts.delete(:tools) || default_citeseer_algorithms

    result = {}

    if !(tools & default_citeseer_algorithms).empty?
      result.merge! CiteSeer.extract(file, false)
    end

    if tools.include?(:parshed_token)
      result.merge!( parshed_token: CiteSeer.extract(file, true)[:parshed] )
    end

    if tools.include?(:cb2bib)
      result.merge!( cb2bib: Cb2Bib.extract(file, opts) )
    end

    result
  end

end
