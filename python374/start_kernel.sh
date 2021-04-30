#!/bin/bash

source /etc/profile.d/z01_modules.sh &>/dev/null 
source /usr/share/lmod/lmod/init/bash &>/dev/null 
module purge

module use /data/leuven/software/biomed/skylake_centos7/2018a/modules/all &>/dev/null 
module load BiomedBundle/20190901-foss-2018a-Python-3.7.4 &>/dev/null

ipython kernel -f "$1"