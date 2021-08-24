#!/bin/bash

for filename in *.zip; do
	unzip $filename
	
	filename=(${filename//./ })
	
	mkdir inverted_indexes/$filename
	
	cd $filename

	start=`date +%s.%N`
	bash index.sh ../enwiki-latest-pages-articles17.xml-p23570393p23716197 ../inverted_indexes/$filename invertedindex_stat.txt
	end=`date +%s.%N`
	runtime=$( echo "$end - $start" | bc -l )
	
	echo "RUNTIME: "$runtime > "$filename""_eval_results.txt"
	echo " " >> "$filename""_eval_results.txt"

	mv invertedindex_stat.txt "$filename""_stats.txt"
	
	cat ../queries.txt | while read query; do
		bash search.sh ../inverted_indexes/$filename $query >> "$filename""_eval_results.txt"
	done

	echo " " >> "$filename""_eval_results.txt"

	size_index=`du -sh ../inverted_indexes/$filename`
	size_index=(${size_index//../ })

	echo "INDEX SIZE: "$size_index >> "$filename""_eval_results.txt"

	cd ..
	mv $filename/"$filename""_eval_results.txt" $filename/"$filename""_stats.txt" results
	rm -r $filename
	rm -r inverted_indexes/$filename
done