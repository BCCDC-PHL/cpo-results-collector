#!/bin/bash

ls -1d $1/* | tac | while read d; 
do
    run_id=$(basename $d);
    if [[ ! -f output_by_run/${run_id}_core.tsv || ! -f output_by_run/${run_id}_plasmid.tsv ]]; then
	./cpo-results-collector -d $d --output output_by_run/${run_id}_core.tsv --plasmid-output output_by_run/${run_id}_plasmid.tsv
	echo $run_id;
    fi
    
done

tail -qn+2 output_by_run/*_core.tsv > collected_output/core_data.tsv
tail -qn+2 output_by_run/*_plasmid.tsv > collected_output/plasmid_data.tsv

cat core_header.tsv ./collected_output/core_data.tsv > ./collected_output/$(date --iso)_cpo_results_core.tsv
cat plasmid_header.tsv  ./collected_output/plasmid_data.tsv > ./collected_output/$(date --iso)_cpo_results_plasmid.tsv

rm collected_output/core_data.tsv
rm collected_output/plasmid_data.tsv
