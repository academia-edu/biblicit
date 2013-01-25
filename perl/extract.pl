#!/usr/bin/perl -CSD
#use strict;
use FindBin;

use lib "$FindBin::Bin/FileConversionService/lib";
use lib "$FindBin::Bin/DocFilter/lib";
use lib "$FindBin::Bin/ParsCit/lib";
use lib "$FindBin::Bin/HeaderParseService/lib";

use DBI;
use DocFilter::Filter;
use ParsCit::Controller;
use HeaderParse::API::Parser;
use HeaderParse::Config::API_Config;

my $logDir = "$FindBin::Bin/log";

my $xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";

system("mkdir","-p","$logDir");

open (LOG, ">>$logDir/prep.log");
open (ERR, ">>$logDir/prep.err");

my $argc = scalar(@ARGV);

if ($argc != 2) {
  print "Usage: ./extract.pl path_to_input path_to_output\n";
  exit 1;
}

my $inputPath = $ARGV[0];
my $outputPath = $ARGV[1];

import($inputPath, $outputPath);

close LOG;
close ERR;

exit;

sub import {
    my ($filePath, $id) = @_;

    system("mkdir","-p","$id");
    
    my ($status, $msg) = prep($filePath, $id);
    if ($status == 0) {
	    print ERR "$id: $msg\n";
    }
    if ($status == 1) {
	    print LOG "$id\n";
    }
}


sub prep {
    my ($textFile, $id) = @_;

    # why do we do this twice?
	  my ($fstatus, $msg) = filter($textFile);
	  if ($fstatus <= 0) {
	    return ($status, $msg);
    }

    my ($fstatus, $msg) = filter($textFile);
    if ($fstatus <= 0) {
	    return ($fstatus, $msg);
    }

    my ($ecstatus, $msg) = extractCitations($textFile, $id);
    if ($ecstatus <= 0) {
	    return ($estatus, $msg);
    }
    
    my ($ehstatus, $msg) = extractHeader($textFile, $id);
    if ($ehstatus <= 0) {
	    return ($ehstatus, $msg);
    }    

    return (1, "");
}



sub checkPDF {
    my $url = shift;
    if ($url =~ m/pdf(\.g?z)?$/i) {
	return 1;
    } else {
	return 0;
    }
}


sub extractText {
    my ($filePath, $id) = @_;
    my ($status, $msg, $textFile, $rTrace, $rCheckSums) =
	FileConverter::Controller::extractText($filePath);
    if ($status <= 0) {
	return ($status, $msg);
    } else {
	unless(open(FINFO, ">$outputPath/out.file")) {
	    return (0, "unable to write finfo: $!");
	}
	print FINFO $xmlHeader;
	print FINFO "<conversionTrace>";
	print FINFO join ",", @$rTrace;
	print FINFO "</conversionTrace>\n";
	print FINFO "<checksums>\n";
	foreach my $checkSum(@$rCheckSums) {
	    print FINFO "<checksum>\n";
	    print FINFO "<fileType>".$checkSum->getFileType()."</fileType>\n";
	    print FINFO "<sha1>".$checkSum->getSHA1()."</sha1>\n";
	    print FINFO "</checksum>\n";
	}
	print FINFO "</checkSums>\n";
	close FINFO;
    }
    return (1, "", $textFile);
}


sub filter {
    my $textFile = shift;
    my ($sysStatus, $filterStatus, $msg) =
	DocFilter::Filter::filter($textFile);
    if ($sysStatus > 0) {
	if ($filterStatus > 0) {
	    return (1);
	} else {
	    return (0, "document failed filtration");
	}
    } else {
	return (0, "An error occurred during filtration: $msg");
    }
}


sub extractCitations {
    my ($textFile, $id) = @_;

    my $rXML = ParsCit::Controller::extractCitations($textFile);

    unless(open(CITE, ">:utf8", "$outputPath/out.parscit")) {
	return (0, "Unable to open parscit file: $!");
    }

    print CITE $$rXML;
    close CITE;
    return (1);
}


sub extractHeader {
    my ($textFile, $id) = @_;

    my $jobID;
    while($jobID = rand(time)) {
	unless(-f $offlineD."$jobID") {
	    last;
	}
    }

    my ($status, $msg, $rXML) =
	HeaderParse::API::Parser::_parseHeader($textFile, $jobID);

    if ($status <= 0) {
	return ($status, $msg);
    }

    unless(open(HEAD, ">:utf8", "$outputPath/out.header")) {
	return (0, "Unable to open header file: $!");
    }

    print HEAD $$rXML;
    close HEAD;
    return (1);

}
