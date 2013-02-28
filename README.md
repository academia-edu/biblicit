biblicit
=============

Extract citations from PDFs.

Note: The version is 2.x, but really should be 0.2.x.


# Usage

```ruby
  # Extract metadata from a file using default tools and settings
  result = Biblicit::Extractor.extract(content: "a string containing the content of a PDF file")

  # Extract metadata from a file using all available tools
  result = Biblicit::Extractor.extract(file: "myfile.pdf", tools: [:citeseer, :parshed, :cb2bib], remote: true, token: false)

  # See reference information for "myfile.pdf"
  result[:citeseer][:title]
  result[:parshed][:title]
  result[:citeseer][:authors]
  # etc
```


# Algorithms

### CiteSeer (default)

Wrapper around Perl code extracted from [CiteSeerX](http://citeseer.ist.psu.edu/). 

Uses a model trained with the [svm-light](http://svmlight.joachims.org/) Support Vector Machine library.

### ParsCit (default) 

Wrapper around Perl & Ruby code from [ParsCit](http://aye.comp.nus.edu.sg/parsCit/), which is included as a Git submodule.

Uses a model trained with the [CRF++](http://code.google.com/p/crfpp/) Conditional Random Fields library.

### cb2Bib

Wrapper around [cb2Bib](http://www.molspaces.com/cb2bib/) in command-line mode.

Uses an apparently less-sophisticated parsing algorithm than the others to parse metadata, but then, if :remote=true, scrapes one of a large number of journal or public repository websites for a structured version of the citation data. Warning: sometimes it finds the wrong work!


# Requirements

There are a lot, but you may not need all of them, depending on your use case.


## Required to support various input file formats

Different tools are used for different input file formats.

#### PDF - [Poppler](http://poppler.freedesktop.org/)

This provides `pdftotext`. You could install `xpdf` instead.

##### From source

Requires fontconfig.

    wget http://poppler.freedesktop.org/poppler-0.22.1.tar.gz
    tar -xzf poppler-0.22.1.tar.gz
    cd poppler-0.22.1
    ./configure
    make
    sudo make install

##### On Debian/Ubuntu

    sudo apt-get install poppler-utils

##### On OS X with Homebrew

    brew install poppler

#### Postscript - [Ghostscript](http://www.ghostscript.com/)

This provides `ps2ascii`.

##### From source

    wget http://downloads.ghostscript.com/public/ghostscript-9.06.tar.gz
    tar -xzf ghostscript-9.06.tar.gz
    cd ghostscript-9.06
    make
    sudo make install

##### On Debian/Ubuntu

    sudo apt-get install ghostscript

##### On OS X with Homebrew

    brew install ghostscript

#### Other (e.g. docx) - [AbiWord](http://www.abisource.com/)

This provides `abiword`.

##### On Debian/Ubuntu

    sudo apt-get install abiword

##### On OS X

As of writing, you're out of luck, because AbiWord doesn't compile on recent versions of OS X. According to their website, however, this is being actively worked on.


## Required to use either the ParsCit or CiteSeer algorithms

#### Perl modules

More than these might be required; this is what I had to add to my default installation.

##### From CPAN

    sudo cpan install Digest::SHA1
    sudo cpan install String::Approx
    sudo cpan install XML::Writer::String
    sudo cpan install XML::Twig

## Required to use the ParsCit algorithm

#### CRF++

You can specify where you have installed CRF++ by setting the CRFPP_HOME environment variable.
 
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
    sudo apt-get install libcrf++ crf++

##### On OS X with Homebrew

    brew install crf++

## Required to use the CiteSeer algorithm

#### svm-light

Required for header extraction (reference information for the input work itself).

The included model requires version 5, not the current version. You can specify where you have installed svm-light by setting the SVM_LIGHT_HOME environment variable.

##### From source

    mkdir svm_light5
    cd svm_light5
    wget http://download.joachims.org/svm_light/v5.00/svm_light.tar.gz
    tar -xzf svm_light.tar.gz
    make
    echo "export SVM_LIGHT_HOME=`pwd`" >> ~/.profile # or .bashrc or whatever
    source ~/.profile

## Required to use the cb2bib algorithm

#### cb2Bib

##### From source (Linux)

    wget http://www.molspaces.com/dl/progs/cb2bib-1.4.9.tar.gz
    tar -xzvf cb2bib-1.4.9.tar.gz
    cd cb2bib-1.4.9
    ./configure --prefix /usr/local
    make
    sudo make install

##### From source (OS X)

Requires Qt & X11, unfortunately, and still requires a hack to work on recent versions of OS X.

    wget http://www.molspaces.com/dl/progs/cb2bib-1.4.9.tar.gz
    tar -xzvf cb2bib-1.4.9.tar.gz
    cd cb2bib-1.4.9
    ./configure --prefix /Applications/cb2Bib
    make # fails first time...
    mv src/Makefile src/Makefile.old
    sed 's|-lX11 -framework QtWebKit|-lX11 -L/usr/X11/lib -I/usr/X11/include -framework QtWebKit|' src/Makefile.old > src/Makefile
    make # should succeed now
    sudo make install

##### On Debian/Ubuntu

    sudo apt-get install cb2bib


## Other

(I'm not currently sure what this was required for; TODO figure it out!)

##### On Debian/Ubuntu

    sudo apt-get install libicu-dev


# Copying

Copyright Academia.edu or the original author(s) - see documentation in the included parscit and svm-header-parse directories.

Apache licensed (see LICENSE.TXT).

Please note svm-light is in general free only for non-commercial use, but can be used in this gem by permission of the author. For conditions on additional uses see [the website](http://svmlight.joachims.org/).
