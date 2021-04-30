#!/bin/bash

source /etc/profile.d/z01_modules.sh &>/dev/null 
source /usr/share/lmod/lmod/init/bash &>/dev/null 
module purge

module use /data/leuven/software/biomed/skylake_centos7/2018a/modules/all &>/dev/null 
module load Seurat/3.1.0-foss-2018a-R-3.6.1-X11-20180604 &>/dev/null

R --slave -e 'options(bitmapType="cairo") ; IRkernel::main()' --args "$1"