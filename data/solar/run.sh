b=1
for a in {A..Z}
do
	echo ${a} ${b}
	sed -i.bu 's/${a}/${b}/g' flare.data2.txt
	b=$((${b}+1));
done
