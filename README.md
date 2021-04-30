# VSC_Jupyterhub_Kernels
Kernels for use with Jupyterhub instance at VSC

# Custom Kernels
Using custom kernels in Jupyterhub is possible by adding the correct files to `~/.local/share/jupyter/kernels/`.

Make a folder using this folder structure with a unique name for the kernel and then modify the files following one of the examples below.

```
~/.local/share/jupyter/kernels/
├── scanpy144
│   ├── kernel.json
|   └── logo-64x64.png (Optional for custom logo)
└── seurat310
    ├── kernel.json
    └── start_kernel.sh
```

# Example Kernels
Basic kernels using a singularity image can be set up as follows:

`kernel.json`
```json
{
    "argv": [
     "singularity",
     "exec",
     "-B",
     "/staging,/lustre1,/data,/vsc-hard-mounts",
     "/staging/leuven/res_00001/software/Scanpy/1.4.4/scanpy-1.4.4-jpytr.sif",
     "ipython",
     "kernel",
     "-f",
     "{connection_file}"
    ],
    "display_name": "Scanpy 1.4.4",
    "language": "python"
   }

```
`/staging/leuven/res_00001/software/Scanpy/1.4.4/scanpy-1.4.4-jpytr.sif` should be replaced with the path to your singularity image and the lines following this should be corrected to the commands required to start your kernel. Display name will show inside jupyterhub and selecting the correct language will allow syntax highlighting.

More complicated kernels which require a conda environemnt or modules loading should use the following configurations:

`kernel.json`
```json
{
 "argv": [
    "/data/leuven/software/biomed/jupyterhub/miniconda/envs/jupyterhub/share/jupyter/kernels/seurat310/start_kernel.sh",
    "{connection_file}"
 ],
 "display_name": "Seurat 3.1.0",
 "language": "R"
}
```
In this case, the `argv` should point to an executable script which takes in a single argument, such as the following for a kernel using the module system:

```bash
#!/bin/bash

# Load the module system manually as it isn't loaded during a non-interactive, non-login ssh connection
source /etc/profile.d/z01_modules.sh &>/dev/null 
source /usr/share/lmod/lmod/init/bash &>/dev/null 
module purge

module use /data/leuven/software/biomed/skylake_centos7/2018a/modules/all &>/dev/null 
module load Seurat/3.1.0-foss-2018a-R-3.6.1-X11-20180604 &>/dev/null

R --slave -e 'options(bitmapType="cairo") ; IRkernel::main()' --args "$1"
```

or for a conda environment:

```bash
#!/bin/bash

# Always source the conda activate script first
source /data/leuven/309/vsc30922/miniconda3/bin/activate
conda activate scvelo

ipython3 kernel -f "$1"
```
This script can contain any code required to start a kernel, but it must end with a line which takes in the `{connection_file}` and actually starts the kernel.

**NOTE**: `.bashrc`, `.profile` and similar shell init scripts will not be sourced/ran on login, therefore you must do all setup required in the afforementioned scripts.
