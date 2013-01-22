# encoding: UTF-8

describe Cb2Bib do

  PDF_DIR = "#{File.dirname(__FILE__)}/../fixtures/pdf"

  # cb2bib makes remote calls internally
  unless ENV['LOCAL']

    it "gets metadata for a PDF" do
      path = "#{PDF_DIR}/ICINCO_2010.pdf"
      content = IO.read(path)
      parsed = Cb2Bib.extract(content).header

      parsed[:title].should == "Multiscale collaborative searching through swarming"
      parsed[:authors].should == ["W. Liu", "M. B. Short", "Y. E. Taima", "A. L. Bertozzi"]
      parsed[:year].should == 2010
    end

  end

end
