#!/bin/bash

make test
if [[ "$?" != "0" ]]; then
	exit "$?"
fi

if [[ "$1" != "" ]]; then
	./scss $1 > `echo $1 | sed 's/^test/out/'`
	ret=$?
	if [[ "$ret" != "0" ]]; then
		echo -e "$1: \033[31mfailed($ret)\033[0m"
		exit 1
	else
		echo -e "$1: \033[32msuccess\033[0m"
	fi

	outname=`echo $1 | sed 's/^test/out/'`
	rightname=`echo $outname | sed 's/scss$/css/'`
	result=`icdiff $outname $rightname | wc -l`
	if [[ "$result" != "0" ]]; then
		echo -e "$1: \033[31mfailed($ret)\033[0m"
		exit 1
	else
		echo -e "$1: \033[32msuccess\033[0m"
		exit 0
	fi
fi

for file in test/*.scss; do
	./scss $file > `echo $file | sed 's/^test/out/'`
	ret=$?
	if [[ "$ret" != "0" ]]; then
		echo -e "$file: \033[31mfailed($ret)\033[0m"
		./scss $file
		exit 1
	fi

	outname=`echo $file | sed 's/^test/out/'`
	rightname=`echo $outname | sed 's/scss$/css/'`
	result=`icdiff $outname $rightname | wc -l`
	if [[ "$result" != "0" ]]; then
		echo -e "$file: \033[31mfailed($ret)\033[0m"
		icdiff $outname $rightname
	else
		echo -e "$file: \033[32msuccess\033[0m"
	fi
done

echo -e "$0: \033[32mtest finished\033[0m"
exit 0
