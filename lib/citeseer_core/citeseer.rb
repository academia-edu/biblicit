# encoding: UTF-8

module CiteSeer

  PERL_DIR = "#{File.dirname(__FILE__)}/../../perl"

  # note: out_dir will be created if necessary, overwritten otherwise
  def self.extract(in_file, out_dir)
    `#{PERL_DIR}/extract.pl #{in_file} #{out_dir}`
  end

end
