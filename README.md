biblicit
=============

Extract citations from PDFs.

## Usage

```ruby
  # Extract metadata from a file using the code from CiteSeerX
  Biblicit.extract(file: "myfile.pdf", tool: :citeseer)

  # Extract metadata from the contents of a PDF using cb2bib
  Biblicit.extract(contents: IO.read("myfile.pdf"), tool: :cb2bib, remote: true)
```

## Algorithms

### CiteSeer (default)

Wrapper around Perl code extracted from [CiteSeerX](http://citeseer.ist.psu.edu/). 

Uses [Apache PDFBox](http://pdfbox.apache.org/) to extract text from the PDF, uses a model trained with the [svm-light](http://svmlight.joachims.org/) Support Vector Machine library to extract citation data for the PDF itself, and then uses [ParsCit](http://aye.comp.nus.edu.sg/parsCit/)'s model trained with the [CRF++](http://code.google.com/p/crfpp/) Conditional Random Fields library to parse citations from the PDF's bibliography, if any.

### cb2Bib

Wrapper around [cb2Bib](http://www.molspaces.com/cb2bib/) in command-line mode.

Uses pdf2text from [Xpdf](http://www.foolabs.com/xpdf/download.html) to extract text from the PDF, uses an apparently less-sophisticated parsing algorithm than the CiteSeerX code to parse metadata, but then, if :remote=true, scrapes one of a large number of journal or public repository websites for a structured version of the citation data.

## Requirements

### CRF++
 
##### From source

    wget http://crfpp.googlecode.com/files/CRF%2B%2B-0.57.tar.gz
    tar xvzf CRF++-0.57.tar.gz
    cd CRF++-0.57
    ./configure 
    make
    sudo make install

##### On Debian/Ubuntu

    sudo apt-add-repository 'deb http://cl.naist.jp/~eric-n/ubuntu-nlp oneiric all'
    sudo apt-get update
    sudo apt-get install libcrf++

##### On OS X with Homebrew

    brew install crf++

### svm-light

The included model requires version 5, not the current version.

##### From source

    mkdir svm_light5
    cd svm_light5
    wget http://download.joachims.org/svm_light/v5.00/svm_light.tar.gz
    tar -xzf svm_light.tar.gz
    make
    sudo ln -s $(readlink -f "$(dirname svm_classify)/$(basename svm_classify)") /usr/bin/svm_classify5
    sudo ln -s $(readlink -f "$(dirname svm_learn)/$(basename svm_learn)") /usr/bin/svm_learn5

Note: On OS X you'll need to use greadlink instead of readlink if you have coreutils installed, or another workaround for the absence of `-f`.

### Perl modules

##### From CPAN

    sudo cpan install DBI
    sudo cpan install Digest::SHA1
    sudo cpan install Log:Log4perl
    sudo cpan install Log:Dispatch
    sudo cpan install String::Approx

### cb2bib

##### From source

    # TODO: Does not work as-is on OS X
    wget http://www.molspaces.com/dl/progs/cb2bib-1.4.9.tar.gz
    tar -xzvf cb2bib-1.4.9.tar.gz
    cd cb2bib-1.4.9
    ./configure --prefix /usr/local
    make
    sudo make install

##### On Debian/Ubuntu

    sudo apt-get install cb2bib

### Other

##### On Debian/Ubuntu

    sudo apt-get install libicu-dev

## Copying

Copyright Academia.edu or the original author(s).

Apache licensed (see LICENSE.TXT).
