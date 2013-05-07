#!/bin/bash

if [ -z "$2" ]; then
  echo "Usage: ./convert_to_text.sh in.pdf out.txt";
  exit 1;
fi

INPUT=$1
OUTPUT=$2
TYPE=`file -b --mime-type "$INPUT"`

# file occasionally misidentifies plain text as pascal given the presence of certain keywords :(
if [[ "$TYPE" == "text/plain" || "$TYPE" == "text/x-pascal" ]]; then
  cp "$INPUT" "$OUTPUT";
elif [[ "$TYPE" == "application/pdf" && -n `which pdftotext` ]]; then
  pdftotext -raw -enc UTF-8 "$INPUT" "$OUTPUT";
elif [[ "$TYPE" == "application/postscript" && -n `which ps2ascii` ]]; then
  ps2ascii "$INPUT" > "$OUTPUT";
elif [[ -n `which abiword` ]]; then
  abiword -t txt "$INPUT" -o "$OUTPUT";
fi
