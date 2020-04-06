#!/bin/sh

# This software and the related documents are Intel copyrighted materials, and
# your use of them is governed by the express license under which they were
# provided to you (License). Unless the License provides otherwise, you may
# not use, modify, copy, publish, distribute, disclose or transmit this
# software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express
# or implied warranties, other than those that are expressly stated in the
# License.

function genlinks() {
    target="$1"
    shift
    aliases=("$@")
    for i in "${aliases[@]}"
    do
        ln -sv $target $i
    done
}

function help() {
    echo "$1 [-f|--full] [-d=<install dir>|--dir=<install dir>] [-s|--silent]"
    echo "This script restores libraries symbolic links in order to provide backward compatibility with earlier IMPI versions."
    echo "By default script restores only essential links required for most common cases."
    echo "-f|--full     - restore all symbolic links(disabled by default) presented in earlier versions"
    echo "-s|--silent   - suppress any output except error messages"
    echo ""
    echo "-d=<dir>|--dir=<dir> - specifies path to target IMPI package installation. Same values as I_MPI_ROOT of target package. This is mandatory parameter."
    echo ""
    echo "Example:"
    echo "~> source /opt/intel/impi/2019.7/intel64/bin/mpivars.sh"
    echo "~> $1 -dir=\$I_MPI_ROOT"
    exit $2
}


declare -a mpi_core_alias=('libmpi.so.4' 'libmpi.so.5')
declare -a mpi_alias=('libmpi.so.4' 'libmpi.so.5' 'libmpi_mt.so.5' 'libmpi_mt.so.4' 'libmpi_mt.so.12' 'libmpi_mt.so')
declare -a dbg_mpi_alias=('libmpi_dbg.so.4' 'libmpi_dbg.so.5' 'libmpi_dbg_mt.so.5' 'libmpi_dbg_mt.so.4' 'libmpi_dbg_mt.so.12' 'libmpi_dbg_mt.so')

declare -a cxx_binding_alias=('libmpigc4.so.5' 'libmpigc4.so.4' 'libmpigc4.so')
declare -a for_binding_alias=('libmpigf.so.5' 'libmpigf.so.4' 'libmpigf.so')

ROOTDIR=""
FULL_RESTORE=false
SILENT=false

[ $# == 0 ] && { help $0 -1 ; }

for i in "$@"
do
    case $i in
        -f|--full)
            FULL_RESTORE=true
            shift
            ;;
        -d=*|--dir=*)
            ROOTDIR="${i#*=}"
            shift
            ;;
        -s|--silent)
            SILENT=true
            shift
            ;;
        -h|--help)
            help $0 0
            ;;
        *)
            help $0 0
            ;;
    esac
done


LIBDIR="$ROOTDIR/intel64/lib"
BINDIR="$ROOTDIR/intel64/bin"
INCDIR="$ROOTDIR/intel64/include"
ETCDIR="$ROOTDIR/intel64/etc"


if [ ! -d $LIBDIR ] || [ ! -d $BINDIR] || [ ! -d $INCDIR ] || [ ! -d $ETCDIR ]
then
    echo
    echo "ERROR: Unexpected structure of $ROOTDIR directory. Please provide correct path to IMPI installation."
    echo
    help $0 -1
fi

if [! -d intel64/bin]
[ $SILENT == true ] && { exec > /dev/null ; }

cd $ROOTDIR
ln -sv intel64/bin bin64
ln -sv intel64/lib lib64
ln -sv intel64/include include64
ln -sv intel64/etc etc64

cd $LIBDIR
echo "Generating bindings aliases..."
genlinks "libmpicxx.so.12.0.0" "${cxx_binding_alias[@]}"
genlinks "libmpifort.so.12.0.0" "${for_binding_alias[@]}"

echo "Generating libmpi aliases..."
ln -sv release/libmpi.a libmpi.a
if [ $FULL_RESTORE == true ]
then
    genlinks "release/libmpi.so.12.0.0" "${mpi_alias[@]}" ;
    genlinks "debug/libmpi.so.12.0.0" "${dbg_mpi_alias[@]}" ;
else
    for subdir in "release" "debug" "release_mt" "debug_mt"
    do
        cd "$subdir" ;
        echo "Processing subdir: $subdir" ;
        genlinks "libmpi.so.12.0.0" "${mpi_core_alias[@]}" ;
        cd "$OLDPWD" ;
    done
fi
echo "Done"
exit 0
