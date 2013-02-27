# encoding: UTF-8

require 'biblicit/cb2bib'
require 'biblicit/citeseer'
require 'biblicit/parscit'

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
      result.merge! ParsCit.extract(file, opts)
    end

    if tools.include?(:citeseer)
      result.merge!( citeseer: CiteSeer.extract(file, opts) )
    end

    if tools.include?(:cb2bib)
      result.merge!( cb2bib: Cb2Bib.extract(file, opts) )
    end

    result
  end

end
