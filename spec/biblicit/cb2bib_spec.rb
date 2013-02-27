# encoding: UTF-8

describe Cb2Bib do

  unless ENV['LOCAL']

    it "parses 'Multi-scale collaborative...' headers from file" do
      result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf", tool: :cb2bib, remote: true)
      parsed = result.header

      parsed[:title].should == "Multiscale collaborative searching through swarming"
      parsed[:authors].should == ["W. Liu", "M. B. Short", "Y. E. Taima", "A. L. Bertozzi"]
      parsed[:year].should == 2010
    end

  end

  it "parses 'Multi-scale collaborative...' headers from content" do
    content = IO.read("#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")
    result = Biblicit.extract(content: content, tool: :cb2bib, remote: false)
    parsed = result.header

    #parsed[:title].should == "Multiscale collaborative searching through swarming"
    parsed[:authors].should == ["W. Liu", "Y. E. Taima", "M. B. Short", "A. L. Bertozzi"]
    #parsed[:year].should == 2010
  end

  unless ENV['LOCAL']

    it "parses 'Oligopoly, Disclosure...' headers" do
      result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/Bagnoli Watts TAR 2010.pdf", tool: :cb2bib)
      parsed = result.header

      parsed[:doi].should == "10.2308/accr.2010.85.4.1191"
      #parsed[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
      parsed[:authors].should == ["M. Bagnoli", "S. G. Watts"]
    end

    it "parses Google paper headers" do
      result = Biblicit.extract(file: "#{FIXTURES_DIR}/pdf/10.1.1.109.4049.pdf", tool: :cb2bib)
      parsed = result.header

      parsed[:abstract].starts_with?('In this paper, we present Google, a prototype of a large-scale search engine').should be_true
      #parsed[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
      parsed[:authors].should == ['S. Brin', 'L. Page']
    end

    it "handles docx file" do
      pending "Fails because Abiword can't be installed on current versions of OS X"
      result = Biblicit.extract(file: "#{FIXTURES_DIR}/Review_of_Michael_Tyes_Consciousness_Revisited.docx", tool: :cb2bib)
      header = result.header
      header[:valid].should be_true
    end

    it "handles ps file" do
      result = Biblicit.extract(file: "#{FIXTURES_DIR}/KerSch99.ps", tool: :cb2bib)
      header = result.header

      header[:pages].should == "Springer" # hmm...
      #header[:title].should == "Pattern Inference Theory: A Probabilistic Approach to Vision"
      #header[:authors].should == ["Danielkerstenand Paulschratery"]
    end

  end

end
