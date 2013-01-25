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
    tool = opts.delete(:tool) || :citeseer

    if tool == :citeseer
      CiteSeer.extract(file, opts)
    elsif tool == :cb2bib
      Cb2Bib.extract(file, opts)
    else
      raise "Unknown tool #{tool}"
    end
  end

end
