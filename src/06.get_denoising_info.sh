#!/usr/bin/bash
#DianaOaxaca 290823
#Export artefacts to text files


stats="results/03.denoising-stats_v*.qza"

echo "Get tabulate stats"

for version in $stats; do
        out=$(echo $version | sed 's/.qza//g')
	cmd='qiime tools export --input-path '$version' --output-path '$out''
	echo $cmd
	$cmd
done
