#!/usr/bin/bash

#@author: Bastien CHATELON, bastienchatelon@gmail.com, 03/2022
#
#
#This bash script is used to select interesting levels and areas from large climate model output member files.
#Each member is cut in 3 ~5GO files.
#
#It is an automation of CDO commands, then recquires CDO to work.
#

START=$(date +%s)

path_to_data=/media/bastien/Maxtor/PC_François/Cerfacs/Stage
path_to_saved_data=/home/bastien/Documents/Cours/Projet_EMI/Python/data/clim

for i in $(seq 1 30) #30 members
do

if [ -e $path_to_data/zg_day_CNRM-CM6-1_historical_r${i}i1p1f2_gr_19500101-19741231.nc ] && [ -e $path_to_data/zg_day_CNRM-CM6-1_historical_r${i}i1p1f2_gr_19750101-19991231.nc ] && [ -e $path_to_data/zg_day_CNRM-CM6-1_historical_r${i}i1p1f2_gr_20000101-20141231.nc ]

then 
	echo -e "\033[4;32mProcessing member $i.\033[0m"
	

	for file in $path_to_data/zg_day_CNRM-CM6-1_historical_r${i}i1*.nc
	do
	filename=$(basename $file)
	echo "Selecting levels and reducing area with CDO on $filename"
	cdo -f nc select,name=zg,level=50000 -sellonlatbox,-80,30,20,80 $path_to_data/$filename $path_to_saved_data/tmp_$filename
	echo "Done. Temporary file created : tmp_$filename."
	echo "-----------------------------------------------------------------------------------------------------------------------------------------"
	done
	
	echo "Merging member $i temporary files"
	cdo mergetime $path_to_saved_data/tmp_zg_day_CNRM-CM6-1_historical_r${i}i* $path_to_saved_data/zg_day_CNRM-CM6-1_historical_r${i}i1p1f2_gr_19500101-20141231.nc
	echo "-----------------------------------------------------------------------------------------------------------------------------------------"
	
	echo "Removing member $i temporary files"
	rm $path_to_saved_data/tmp_zg_day_CNRM-CM6-1_historical_r${i}i*.nc
	echo "========================================================================================================================================="
	
else
	echo -e "\033[1;31mWARNING :\033[0m One or more files are missing for member no $i. Not processing it."

fi

done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Total computing time : $DIFF seconds"
