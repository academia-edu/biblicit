# encoding: UTF-8

describe Cb2Bib do

  PDF_DIR = "#{File.dirname(__FILE__)}/../fixtures/pdf"

  # cb2bib makes remote calls internally
  unless ENV['LOCAL']

    it "parses 'Multi-scale collaborative...' headers from file" do
      result = Biblicit.extract(file: "#{PDF_DIR}/ICINCO_2010.pdf", tool: :cb2bib)
      parsed = result.header

      parsed[:title].should == "Multiscale collaborative searching through swarming"
      parsed[:authors].should == ["W. Liu", "M. B. Short", "Y. E. Taima", "A. L. Bertozzi"]
      parsed[:year].should == 2010
    end

    it "parses 'Multi-scale collaborative...' headers from content" do
      content = IO.read("#{PDF_DIR}/ICINCO_2010.pdf")
      result = Biblicit.extract(content: content, tool: :cb2bib)
      parsed = result.header

      parsed[:title].should == "Multiscale collaborative searching through swarming"
      parsed[:authors].should == ["W. Liu", "M. B. Short", "Y. E. Taima", "A. L. Bertozzi"]
      parsed[:year].should == 2010
    end

    it "parses 'Oligopoly, Disclosure...' headers" do
      result = Biblicit.extract(file: "#{PDF_DIR}/Bagnoli Watts TAR 2010.pdf", tool: :cb2bib)
      parsed = result.header

      parsed[:valid].should == false # unfortunately
      #parsed[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
      #parsed[:authors].should == ["Mark Bagnoli", "Susan G. Watts"]
    end

    it "parses Google paper headers" do
      result = Biblicit.extract(file: "#{PDF_DIR}/10.1.1.109.4049.pdf", tool: :cb2bib)
      parsed = result.header

      parsed[:valid].should == false # unfortunately
      #parsed[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
      #parsed[:authors].should == ['Sergey Brin']
    end

  end

end
