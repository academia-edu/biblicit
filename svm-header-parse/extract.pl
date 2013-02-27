#!/usr/bin/perl -CSD
use strict;
use FindBin;

use lib "$FindBin::Bin/HeaderParseService/lib";

use HeaderParse::API::Parser;
use HeaderParse::Config::API_Config;

my $argc = scalar(@ARGV);

if ($argc != 2) {
  print "Usage: ./extract.pl path_to_input path_to_output\n";
  exit 1;
}

my $inputPath = $ARGV[0];
my $outputPath = $ARGV[1];

import($inputPath, $outputPath);

exit;

sub import {
    my ($filePath, $id) = @_;

    system("mkdir","-p","$id");
    
    my ($status, $msg) = prep($filePath, $id);
    if ($status == 0) {
	    print STDERR "$id: $msg\n";
    }
    if ($status == 1) {
	    print STDOUT "$id\n";
    }
}


sub prep {
    my ($textFile, $id) = @_;

    my ($ehstatus, $msg) = extractHeader($textFile, $id);
    if ($ehstatus <= 0) {
	    return ($ehstatus, $msg);
    }    

    return (1, "");
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
