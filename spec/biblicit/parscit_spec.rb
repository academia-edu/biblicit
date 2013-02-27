# encoding: UTF-8

describe ParsCit do

  it "parses 'Multi-scale collaborative...' header from file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf", tools: [:parshed])
    header = result[:parshed]
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E Taima", "Martin B Short", "Andrea L Bertozzi"]
  end

  it "parses 'Multi-scale collaborative...' header from content" do
    content = IO.read("#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")
    result = Biblicit.extract(content: content, tools: [:parshed])
    header = result[:parshed]
    header[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
    header[:authors].should == ["Wangyi Liu", "Yasser E Taima", "Martin B Short", "Andrea L Bertozzi"]
  end

  it "parses 'Oligopoly, Disclosure...' headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/Bagnoli Watts TAR 2010.pdf", tools: [:parshed])
    header = result[:parshed]
    header[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
    header[:authors].should == ["Mark Bagnoli Susan G Watts"]
  end

  it "parses Google paper headers" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/10.1.1.109.4049.pdf", tools: [:parshed])
    header = result[:parshed]
    header[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
    header[:authors].should == ['Sergey Brin', 'Lawrence Page']
  end

  it "handles docx file" do
    pending "Fails because Abiword can't be installed on current versions of OS X"
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/Review_of_Michael_Tyes_Consciousness_Revisited.docx", tool: :citeseer)
  end

  it "handles ps file" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/KerSch99.ps", tools: [:parshed], token: true)
    header = result[:parshed]
    #header[:title].should == "Pattern Inference Theory: A Probabilistic Approach to Vision"
    header[:title].should =~ /pattern.*inference.*theory.*a.*probabilistic.*approach.*to.*vision/i
  end

  it "handles ParsCit sample1" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/sample1.txt")
    result[:parshed][:title].should == "A Calculus of Program Transformations and Its Applications"
    result[:parshed][:authors].should == ["Rahma Ben Ayed", "Jules Desharnais", "Marc Frappier", "Ali Mili"]
    result[:sectlabel][:title].should == "A Calculus of Program Transformations and Its Applications"
    result[:sectlabel][:authors].should == ["Rahma Ben Ayed", "Jules Desharnais", "Marc Frappier", "Ali Mili"]
  end

  it "handles ParsCit sample2" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/sample2.txt")
    result[:parshed][:title].should ==  "Explanation-Based Learning of Indirect Speech Act Interpretation Rules"
    result[:parshed][:authors].should == ["David Schulenburg Michael J Pazzani"]
  end

  it "handles ParsCit sample E06" do
    result = Biblicit.extract(file: "#{FIXTURES_DIR}/txt/E06-1050.txt")
    result[:parshed][:title].should == "A Probabilistic Answer Type Model"
    result[:parshed][:authors].should == ["Christopher Pinchak", "Dekang Lin"]
    result[:sectlabel][:title].should == "A Probabilistic Answer Type Model"
    result[:sectlabel][:authors].should == ["Christopher Pinchak", "Dekang Lin"]
  end

end
