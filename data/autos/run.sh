brand=("alfa-romero"  "audi"  "bmw"  "chevrolet"  "dodge"  "honda"  "isuzu"  "jaguar"  "mazda"  "mercedes-benz"  "mercury"  "mitsubishi"  "nissan"  "peugot"  "plymouth"  "porsche"  "renault"  "saab"  "subaru"  "toyota"  "volkswagen"  "volvo")
i=0
for brd in ${brand[*]}
do
	i=$((${i}+1))
	echo ${i} ${brd}
	sed -i "s/${brd}/${i}/g" imports-85.data.txt
done 
fuel=("diesel"  "gas")
i=0
for ful in ${fuel[*]}
do
	i=$((${i}+1))
	echo ${i} ${ful}
	sed -i "s/${ful}/${i}/g" imports-85.data.txt
done 
aspiration=("std"  "turbo")
i=0
for asp in ${aspiration[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
doors=("four"  "two")
i=0
for asp in ${doors[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
body=("hardtop"  "wagon"  "sedan"  "hatchback"  "convertible")
i=0
for asp in ${body[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
wheel=("4wd"  "fwd"  "rwd")
i=0
for asp in ${wheel[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
engine=("front"  "rear")
i=0
for asp in ${engine[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
cylinders=("eight"  "five"  "four"  "six"  "three"  "twelve"  "two")
i=0
for asp in ${cylinders[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
fuel=("1bbl"  "2bbl"  "4bbl"  "idi"  "mfi"  "mpfi"  "spdi"  "spfi")
i=0
for asp in ${fuel[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 
enginetype=("dohc"  "dohcv"  "l"   "ohcf"  "ohcv"  "ohc"  "rotor")
i=0
for asp in ${enginetype[*]}
do
	i=$((${i}+1))
	echo ${i} ${asp}
	sed -i "s/${asp}/${i}/g" imports-85.data.txt
done 

