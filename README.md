# Intel® MPI Library auxiliary files storage

This repository contains auxiliary scripts which help with Intel MPI deployment in different environments.

You can automatically get the latest deployment scripts and more by using the auxiliary file storage feature of the [Intel® MPI Library](https://software.intel.com/en-us/mpi-library). 
The feature is enabled when you run the scripts/aws_impi.sh deployment script for Intel® MPI Library. 

## Usage ##
### aws_impi.sh ###
This script is for AWS [Elastic Fabric Adapter ( EFA)](https://aws.amazon.com/hpc/efa/) - enabled instances. Refer to [Getting Started with EFAs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html#efa-start-impi) for instructions on running the scripts/aws_impi.sh deployment script.
### dir_structure_legacy.sh ###
We have updated the installation path structure in Intel MPI Library 2019.  If you encounter problems related to this change, use the attached script to restore the legacy path structure while you update your code to utilize the new path structure.

## License ##
This software is covered by the MIT License, which is included in the script header.

## Optimization Notice ##
Intel's compilers may or may not optimize to the same degree for non-Intel microprocessors for optimizations that are not unique to Intel microprocessors. These optimizations include SSE2, SSE3, and SSSE3 instruction sets and other optimizations. Intel does not guarantee the availability, functionality, or effectiveness of any optimization on microprocessors not manufactured by Intel. Microprocessor-dependent optimizations in this product are intended for use with Intel microprocessors. Certain optimizations not specific to Intel microarchitecture are reserved for Intel microprocessors. Please refer to the applicable product User and Reference Guides for more information regarding the specific instruction sets covered by this notice.

Notice revision #20110804

*Other names and brands may be claimed as the property of others.
