# encoding: UTF-8

describe CiteSeer do

  PDF_DIR = "#{File.dirname(__FILE__)}/../fixtures/pdf"

  it "parses 'Multi-scale collaborative...' header from file" do
    result = Biblicit.extract(file: "#{PDF_DIR}/ICINCO_2010.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Multi-scale collaborative...' header from content" do
    content = IO.read("#{PDF_DIR}/ICINCO_2010.pdf")
    result = Biblicit.extract(content: content, tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Oligopoly, Disclosure...' headers" do
    result = Biblicit.extract(file: "#{PDF_DIR}/Bagnoli Watts TAR 2010.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
    header[:authors].should == ["Mark Bagnoli", "Susan G. Watts"]
  end

  it "parses Google paper headers" do
    result = Biblicit.extract(file: "#{PDF_DIR}/10.1.1.109.4049.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
    header[:authors].should == ['Sergey Brin']
  end

end
