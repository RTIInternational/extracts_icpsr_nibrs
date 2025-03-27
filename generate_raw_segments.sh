#/bin/bash

file=$1
year=$2

mkdir -p data/raw_data/$year

# victim segment
sed -n -e '/^04/p' $file > ./data/raw_data/$year/victim_segment.txt

sed -n -e '/^01/p' $file > ./data/raw_data/$year/admin_segment.txt

sed -n -e '/^02/p' $file > ./data/raw_data/$year/offense_segment.txt

sed -n -e '/^BH/p' $file > ./data/raw_data/$year/batch_header_segment.txt

# the parser removes the spaces in the monthly reporting column and these are important for converting to ICPSR format
# we'll use the B character to indicate blanks at that position so it doesn't get trimmed out by the parser and then handle the conversion utilizing B to indicate blank
perl -i.bak -lpe 'BEGIN { $from = 234; $to = 269; } (substr $_, ( $from - 1 ), ( $to - $from + 1 ) ) =~ tr/ /B/;' ./data/raw_data/$year/batch_header_segment.txt

sed -n -e '/^03/p' $file > ./data/raw_data/$year/property_segment.txt

sed -n -e '/^05/p' $file > ./data/raw_data/$year/offender_segment.txt

sed -n -e '/^06/p' $file > ./data/raw_data/$year/arrestee_segment.txt

sed -n -e '/^07/p' $file > ./data/raw_data/$year/arrestee_segment_groupb.txt

sed -n -e '/^W6/p' $file > ./data/raw_data/$year/arrestee_segment_window.txt

