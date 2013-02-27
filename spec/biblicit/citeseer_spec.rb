# encoding: UTF-8

describe CiteSeer do

  it "parses 'Multi-scale collaborative...' header from file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf", tools: [:citeseer])
    header = result[:citeseer]
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Multi-scale collaborative...' header from content" do
    content = IO.read("#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")
    result = Biblicit.extract(content: content, tools: [:citeseer])
    header = result[:citeseer]
    header[:valid].should be_true
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]
  end

  it "parses 'Oligopoly, Disclosure...' headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/Bagnoli Watts TAR 2010.pdf", tools: [:citeseer])
    header = result[:citeseer]
    header[:valid].should be_true
    header[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
    header[:authors].should == ["Mark Bagnoli", "Susan G. Watts"]
  end

  it "parses Google paper headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/10.1.1.109.4049.pdf", tools: [:citeseer])
    header = result[:citeseer]
    header[:valid].should be_true
    header[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
    header[:authors].should == ['Sergey Brin']
  end

  it "handles docx file" do
    pending "Fails because Abiword can't be installed on current versions of OS X"
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/Review_of_Michael_Tyes_Consciousness_Revisited.docx", tools: [:citeseer])
    header = result[:citeseer]
    header = result.header
    header[:valid].should be_true
  end

  it "handles ps file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/KerSch99.ps", tools: [:citeseer])
    header = result[:citeseer]
    header[:valid].should be_true
    header[:title].should_not be_empty
    #header[:authors].should == ["Daniel Kersten", "Paul Schratery"]
    header[:authors].first.should =~ /daniel.*kersten.*paul.*schratery/i
  end

  it "handles ParsCit sample1" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/sample1.txt", tools: [:citeseer])
    result[:citeseer][:title].should == "A Calculus of Program Transformations and Its Applications"
    result[:citeseer][:authors].should == ["Rahma Ben Ayed", "Jules Desharnais", "Ali Mili"]
  end

  it "handles ParsCit sample2" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/sample2.txt", tools: [:citeseer])
    result[:citeseer][:title].should ==  "Explanation-Based Learning of Indirect Speech Act Interpretation Rules"
    result[:citeseer][:authors].should == ["David Schulenburg", "Michael J. Pazzani"]
  end

  it "handles ParsCit sample E06" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/E06-1050.txt", tools: [:citeseer])
    result[:citeseer][:title].should == "A Probabilistic Answer Type Model"
    result[:citeseer][:authors].should == ["Christopher Pinchak", "Dekang Lin"]
  end

end
