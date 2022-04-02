#!/bin/bash

#@author: Bastien CHATELON, bastienchatelon@gmail.com, 03/2022

START=$(date +%s)

path_to_saved_data=/home/bastien/Documents/Cours/Projet_EMI/Python/data/clim

for file in $path_to_saved_data/zg_day_CNRM-CM6-1_historical*.nc
do

filename=$(basename $file)
echo $filename
cdo -f nc -chname,zg,z $path_to_saved_data/$filename tmp1.nc
ncwa -a plev tmp1.nc tmp2.nc
ncks -C -x -v time_bnds,plev tmp2.nc $path_to_saved_data/past/z${filename:2:60}
rm tmp*.nc

done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Total computing time : $DIFF seconds"
