package ParsCit::Config;


## Global

$algorithmName = "ParsCit";
$algorithmVersion = "1.0";


## Repository Mappings

%repositories = ('rep1' => '/repositories/rep1',
                 'example1' => '/',
		 'example2' => '/home',
		 );


## WS settings

$serverURL = '130.203.133.46';
$serverPort = 10555;
$URI = 'http://citeseerx.org/algorithms/parscit/wsdl';


## Tr2crfpp
## Paths relative to ParsCit root dir ($FindBin::Bin/..)

$tmpDir = "tmp";
$dictFile = "resources/parsCitDict.txt";
$modelFile = "resources/parsCit.model";

if ($ENV{'CRFPP_HOME'}.length) {
  $crf_test = "$ENV{'CRFPP_HOME'}/crf_test" 
}
else {
  $crf_test = "crf_test"; # assume on path
}

## Citation Context

$contextRadius = 200;
$maxContexts = 5;
$context_premark = "=-=";
$context_postmark = "-=-";

## Write citation and body file components

$bWriteSplit = 1;


1;
