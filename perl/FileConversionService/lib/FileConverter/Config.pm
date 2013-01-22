#
# Copyright 2007 Penn State University
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
package FileConverter::Config;

use FindBin;

## Conversion utilities

# valid options are TET or PDFBOX
$PDFTOTEXT = "PDFBOX";

# valid options are TEXT or PDF
$PSConversion = "TEXT";

$TETPath = "$FindBin::Bin/../converters/TET-2.2-Linux/bin/tet";

$TETLicensePath =
    "$FindBin::Bin/../converters/TET-2.2-Linux/licensekeys.txt";

$PDFBoxLocation = "$FindBin::Bin/FileConversionService/converters/PDFBox/pdfbox-app-1.7.1.jar";

$JODConverterPath = 
    "$FindBin::Bin/../converters/jodconverter-2.2.0/jodconverter-cli-2.2.0.jar";

$PrescriptPath = "/usr/local/bin/prescript";

## Compression utilities

$gunzip = "/usr/bin/gunzip";
$uncompress = "/usr/bin/uncompress";
$unzip = "/usr/bin/unzip";


## Repository Mappings

%repositories = ('example1' => '/',
        		 'example2' => '/home',
                );


## WS settings

$serverURL = '127.0.0.1';
$serverPort = 10888;
$URI = 'http://citeseerx.org/fileConversion/wsdl';

1;
