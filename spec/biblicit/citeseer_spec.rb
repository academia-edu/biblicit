# encoding: UTF-8

describe CiteSeer do

  it "parses 'Multi-scale collaborative...' header from file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Multi-scale collaborative...' header from content" do
    content = IO.read("#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")
    result = Biblicit.extract(content: content, tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Oligopoly, Disclosure...' headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/Bagnoli Watts TAR 2010.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
    header[:authors].should == ["Mark Bagnoli", "Susan G. Watts"]
  end

  it "parses Google paper headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/10.1.1.109.4049.pdf", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
    header[:authors].should == ['Sergey Brin']
  end

  it "handles docx file" do
    pending "Fails because Abiword can't be installed on current versions of OS X"
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/Review_of_Michael_Tyes_Consciousness_Revisited.docx", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
  end

  it "handles ps file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/KerSch99.ps", tool: :citeseer)
    header = result.header
    header[:valid].should be_true
    header[:title].should_not be_empty
    #header[:title].should == "Pattern Inference Theory: A Probabilistic Approach to Vision"
    header[:authors].should == ["Danielkerstenand Paulschratery"]
  end

end
