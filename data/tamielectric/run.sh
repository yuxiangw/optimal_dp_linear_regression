type=("Bank" "AutomobileIndustry"   "BpoIndustry"   "CementIndustry"   "Farmers1"   "Farmers2"   "HealthCareResources"   "TextileIndustry"   "PoultryIndustry"   "Residential(individual)"   "Residential(Apartments)"   "FoodIndustry"   "ChemicalIndustry"   "Handlooms"   "FertilizerIndustry"  "Hostel"  "Hospital"   "Supermarket"  "Theatre"   "University")
index=0
for i in ${type[@]}
do
	index=$((${index}+1))
	echo ${i} ${index}
	sed -i "s/${i}/${index}/g" eb.arff

done
serviceId=("671004572"   "457008451"   "581000256"   "775001231"   "455007891"   "562321452"   "450023897"   "785200123"   "568730109"   "609822556"   "894536726"   "978045321"   "5783456902"   "819034567"   "945678934" "486589321"   "389457902"   "256835671"   "198346752"   "286130985"   "374897109"   "498710889"   "693421673"   "785643218"   "785643223"   "652132542"   "450012212"   "548542561"   "524100231"   "600124212"  "800145754")
index=0
for i in ${serviceId[@]}
do
	index=$((${index}+1))
	echo ${i} ${index}
	sed -i "s/${i}/${index}/g" eb.arff
done

