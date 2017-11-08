#!/usr/bin/env sh

# Trap errors #
error() {
  # Dump error location #
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi

  # Exit with original error code #
  exit "${code}"
}
trap 'error ${LINENO}' ERR

readonly libName=$1
readonly libPath=$2
readonly objectToRemove=$3

echo "Will remove $objectToRemove.o from $libPath/$libName.a"

pushd .
mkdir -p $libPath
cd $libPath

echo ""
echo "$libName"
echo "Checking for $objectToRemove.o in $libName.a"

if [[ $(nm -A $libName.a | grep $objectToRemove) ]]; then
    echo "$libName.a contains $objectToRemove.o and will remove it"
else
    echo "$libName.a does not contain $objectToRemove.o"
    exit 0
fi

architecturesString=$(lipo -info $libName.a)
echo ""
echo "$architecturesString"
prefix="Architectures in the fat file: $libName.a are:"
architecturesString=${architecturesString#$prefix}
architectures=($architecturesString)

thinLibraries=()
for architecture in "${architectures[@]}"
do
    echo ""
    echo "Creating thin library for $architecture architecture: $libName-$architecture.a"

    lipo -thin $architecture $libName.a -output $libName-$architecture.a

    if [ -d $libName-$architecture ] ; then
        rm -R $libName-$architecture
    fi
    mkdir $libName-$architecture

    pushd .
    cd $libName-$architecture
    ar -x ../$libName-$architecture.a

    echo "Stripping $objectToRemove.o from thin library: $libName-$architecture.a"

    rm $objectToRemove.o
    libtool -static *.o -o ../$libName-$architecture.a
    popd

    rm -R $libName-$architecture

    thinLibraries+=("$libName-$architecture.a")
done

echo ""
echo "Recombining thin libraries: ${thinLibraries[*]} into a fat library: $libName.a"

cp $libName.a $libName-bak.a
lipo -create ${thinLibraries[*]} -output $libName.a

for thinLibrary in "${thinLibraries[@]}"
do
    rm $thinLibrary;
done

if [[ $(nm -A $libName.a | grep $objectToRemove) ]]; then
    echo "$objectToRemove.o still exists in $libName.a"
    echo "FAILED TO REMOVE $objectToRemove.o FROM $libName.a"
    exit 1
else
    echo "Successfully removed $objectToRemove.o from $libName.a"
fi

popd

exit 0
