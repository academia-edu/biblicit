biblicit
=============

Perl ingestion service code extracted from [Citeseerx](http://citeseer.ist.psu.edu/)

## Requirements

CRF++ must be installed and on your path. Currently binaries for svm-light and PDFBox are checked in. :(

### Installing CRF++
 
#### From source

    wget http://crfpp.googlecode.com/files/CRF%2B%2B-0.57.tar.gz
    tar xvzf CRF++-0.57.tar.gz
    cd CRF++-0.57
    ./configure 
    make
    sudo make install

#### On Ubuntu

    sudo apt-add-repository 'deb http://cl.naist.jp/~eric-n/ubuntu-nlp oneiric all'
    sudo apt-get update
    sudo apt-get install libcrf++

#### On OS X with Homebrew

    brew install crf++

