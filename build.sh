#!/bin/bash

if [ "$3" == "" ]
then 
echo Missing target directory, platform, and dateZ arguments
exit
fi

export UBLversion=2.3
export UBLstage=csprd03

export targetdir=$1
export platform=$2
export label=$3
export package=codelists
export UBLversionStage=UBL-$UBLversion-$UBLstage
bash make-UBL-code-lists.sh

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $targetdir
if [ -f $package-$UBLversionStage-$label-archive-only.zip ]; then rm $package-$UBLversionStage-$label-archive-only.zip ; fi
7z a $package-$UBLversionStage-$label-archive-only.zip $package-$UBLversionStage-$label-archive-only
if [ -f $package-$UBLversionStage-$label.zip ]; then rm $package-$UBLversionStage-$label.zip ; fi
if [ -d $package-$UBLversionStage-$label ]; then 7z a $package-$UBLversionStage-$label.zip $package-$UBLversionStage-$label ; fi
popd

if [ "$targetdir" = "target" ]
then
if [ "$platform" = "github" ]
then
if [ "$6" = "DELETE-REPOSITORY-FILES-AS-WELL" ] #secret undocumented failsafe
then
# further reduce GitHub storage costs by deleting repository files

find . -not -name $targetdir -not -name .github -maxdepth 1 -exec rm -r -f {} \;

mv $targetdir/$package-$UBLstage-$label-archive-only.zip .
mv $targetdir/$package-$UBLstage-$label.zip .
rm -r -f $targetdir

fi
fi
fi

exit 0 # always be successful so that github returns ZIP of results
