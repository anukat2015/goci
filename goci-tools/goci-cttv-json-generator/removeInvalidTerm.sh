#!/bin/sh

#Thiscodeistoremovethejsonstringcontainingefotermsconsideredasinvalid
#bycttv(notdiseasenorphenotypes).

old_IFS=$IFS      # save the field separator
IFS=$'\n'     # new field separator, the end of line

RELEASE_FILE="/Users/catherineleroy/Documents/cttv_gwas_releases/november_2015/cttv009-05-11-2015.json"
RELEASE_FILE_COPY="/Users/catherineleroy/Documents/cttv_gwas_releases/november_2015/cttv009-05-11-2015.json.copy"

cp $RELEASE_FILE $RELEASE_FILE_COPY

INTERMEDIATE_FILE="/Users/catherineleroy/Documents/cttv_gwas_releases/november_2015/cttv009-05-11-2015-indermediate.json"

COUNT=`cat $RELEASE_FILE | wc -l `
echo "count = $COUNT"
for line in $(cat ./efoTerms.tab)
do

   cat $RELEASE_FILE | grep -v "$line" > $INTERMEDIATE_FILE
   cp $INTERMEDIATE_FILE  $RELEASE_FILE

done
IFS=$old_IFS

COUNT=`cat $RELEASE_FILE | wc -l `
echo "count = $COUNT"

