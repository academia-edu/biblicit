# encoding: UTF-8

require 'tmpdir'

describe CiteSeer do

  PDF_DIR = "#{File.dirname(__FILE__)}/../fixtures/pdf"

  it "runs" do
    Dir.mktmpdir do |dir|
      CiteSeer.extract("#{PDF_DIR}/ICINCO_2010.pdf", dir)
    end
  end

end
