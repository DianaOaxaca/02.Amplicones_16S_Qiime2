mkdir -p results/{00.fastqc,00.trimgalore}

FASTQ=$(ls data/*.fastq.gz | sed 's/_.*.$//' | sed 's/data\///' | sort -u)
declare -a FASTQs=("$FASTQ")

for FILE in ${FASTQs[@]}; do
	echo $FILE
	#FASTQCline='fastqc data/'$FILE'_1.fastq.gz  data/'$FILE'_2.fastq.gz -o results/00.fastqc/'
	TRIMline='trim_galore --fastqc --illumina  --trim-n --gzip  --paired data/'$FILE'_1.fastq.gz  data/'$FILE'_2.fastq.gz -o results/00.trimgalore/'$FILE'_trimgalore'
	echo -e $FASTQCline"\n"$TRIMline 
	$TRIMline 
done
