brand=("adviser"  "amdahl"  "apollo"  "basf"  "bti"  "burroughs"  "c.r.d"  "cambex"  "cdc"  "dec"  "dg"  "formation"  "four-phase"  "gould"  "honeywell"  "hp"  "ibm"  "ipl"  "magnuson"  "microdata"  "nas"  "ncr"  "nixdorf"  "perkin-elmer"  "prime"  "siemens"  "sperry"  "sratus"  "wang", "harris")
i=0;
for brd in ${brand[*]}
do
	i=$((${i} + 1))
	echo ${i} ${brd}
	sed -i.au "s/${brd}/${i}/g" machine.data.txt
done
#cut -d " " -f 1,3-10 machine.data.txt
