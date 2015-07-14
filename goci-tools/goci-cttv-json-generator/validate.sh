#!/bin/bash

cd /Users/catherineleroy/Applications/json_schema/examples

LINE_COUNT=`wc -l < /Users/catherineleroy/Documents/cttv_gwas_releases/july_2015/goci/goci-tools/goci-cttv-json-generator/gwas.json`

echo $LINE_COUNT

COUNTER=0
while [  $COUNTER -lt $LINE_COUNT ]; do
	echo The counter is $COUNTER
	head -n 2 /Users/catherineleroy/Documents/cttv_gwas_releases/july_2015/goci/goci-tools/goci-cttv-json-generator/gwas.json | tail -n 1 > /Users/catherineleroy/Documents/cttv_gwas_releases/july_2015/goci/goci-tools/goci-cttv-json-generator/gwas-test.json
	EXIT_CODE=`z-schema ../src/genetics.json /Users/catherineleroy/Documents/cttv_gwas_releases/july_2015/goci/goci-tools/goci-cttv-json-generator/gwas-test.json`
	if [ "$EXIT_CODE" -ne "0" ]; then
		echo 'problem with file /Users/catherineleroy/Documents/cttv_gwas_releases/july_2015/goci/goci-tools/goci-cttv-json-generator/gwas-test.json'
		exit 1
	fi	
	let COUNTER=COUNTER+1
done

