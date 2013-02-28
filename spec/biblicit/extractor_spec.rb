# encoding: UTF-8

module Biblicit

  describe Extractor do

    unless ENV['LOCAL']
      it "handles 'Multi-scale collaborative...' using remote cb2bib" do
        result = Extractor.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf", tools: [:cb2bib], remote: true)

        cb2bib = result[:cb2bib]
        cb2bib[:title].should == "Multiscale collaborative searching through swarming"
        cb2bib[:authors].should == ["W. Liu", "M. B. Short", "Y. E. Taima", "A. L. Bertozzi"]
        cb2bib[:year].should == 2010
      end
    end

    it "handles 'Multi-scale collaborative...' " do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")

      citeseer = result[:citeseer]
      citeseer[:valid].should be_true
      citeseer[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
      citeseer[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]

      parshed = result[:parshed]
      parshed[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
      parshed[:authors].should == ["Wangyi Liu", "Yasser E Taima", "Martin B Short", "Andrea L Bertozzi"]
   end

    it "handles 'Multi-scale collaborative...' " do
      content = IO.read("#{FIXTURES_DIR}/pdf/ICINCO_2010.pdf")
      result = Extractor.extract(content: content)

      citeseer = result[:citeseer]
      citeseer[:valid].should be_true
      citeseer[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
      citeseer[:authors].should == ["Wangyi Liu", "Yasser E. Taima", "Martin B. Short", "Andrea L. Bertozzi"]

      parshed = result[:parshed]
      parshed[:title].should == 'MULTI-SCALE COLLABORATIVE SEARCHING THROUGH SWARMING'
      parshed[:authors].should == ["Wangyi Liu", "Yasser E Taima", "Martin B Short", "Andrea L Bertozzi"]
    end

    it "handles 'Oligopoly, Disclosure...'" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/pdf/Bagnoli Watts TAR 2010.pdf")

      citeseer = result[:citeseer]
      citeseer[:valid].should be_true
      citeseer[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
      citeseer[:authors].should == ["Mark Bagnoli", "Susan G. Watts"]

      parshed = result[:parshed]
      parshed[:title].should == 'Oligopoly, Disclosure, and Earnings Management'
      parshed[:authors].should == ["Mark Bagnoli Susan G Watts"]
    end

    it "handles Google paper" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/pdf/10.1.1.109.4049.pdf")

      citeseer = result[:citeseer]
      citeseer[:valid].should be_true
      citeseer[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
      citeseer[:authors].should == ['Sergey Brin']

      parshed = result[:parshed]
      parshed[:title].should == 'The Anatomy of a Large-Scale Hypertextual Web Search Engine'
      parshed[:authors].should == ['Sergey Brin', 'Lawrence Page']
    end

    it "handles docx file" do
      pending "Fails because Abiword can't be installed on current versions of OS X"
      result = Extractor.extract(file: "#{FIXTURES_DIR}/Review_of_Michael_Tyes_Consciousness_Revisited.docx")
    end

    it "handles ps file" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/critical-infrastructures.ps")

      citeseer = result[:citeseer]
      citeseer[:valid].should be_true
      citeseer[:title].should == "Critical Infrastructures You Can Trust:  Where Telecommunications Fits"
      citeseer[:authors].should == ["Productname Gpl Ghostscript", "Fred B. Schneider", "Steven M. Bellovin", "Alan S. Inouye"]

      parshed = result[:parshed]
      parshed[:title].should == "Critical Infrastructures You Can Trust: Where Telecommunications Fits"
      parshed[:authors].should == ["Fred B Schneider", "Cornell University Steven M Bellovin", "AT&T Labs-Research Alan S Inouye", "Computer Science", "Telecommunications Board"] # not ideal, but ok to match against
    end

    it "handles ParsCit sample1" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/txt/sample1.txt")

      result[:citeseer][:title].should == "A Calculus of Program Transformations and Its Applications"
      result[:citeseer][:authors].should == ["Rahma Ben Ayed", "Jules Desharnais", "Ali Mili"]

      result[:parshed][:title].should == "A Calculus of Program Transformations and Its Applications"
      result[:parshed][:authors].should == ["Rahma Ben Ayed", "Jules Desharnais", "Marc Frappier", "Ali Mili"]
    end

    it "handles ParsCit sample2" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/txt/sample2.txt")

      result[:citeseer][:title].should ==  "Explanation-Based Learning of Indirect Speech Act Interpretation Rules"
      result[:citeseer][:authors].should == ["David Schulenburg", "Michael J. Pazzani"]

      result[:parshed][:title].should ==  "Explanation-Based Learning of Indirect Speech Act Interpretation Rules"
      result[:parshed][:authors].should == ["David Schulenburg Michael J Pazzani"]
   end

    it "handles ParsCit sample E06" do
      result = Extractor.extract(file: "#{FIXTURES_DIR}/txt/E06-1050.txt")

      result[:citeseer][:title].should == "A Probabilistic Answer Type Model"
      result[:citeseer][:authors].should == ["Christopher Pinchak", "Dekang Lin"]

      result[:parshed][:title].should == "A Probabilistic Answer Type Model"
      result[:parshed][:authors].should == ["Christopher Pinchak", "Dekang Lin"]
   end

  end

end
