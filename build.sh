#!/bin/bash

if [ "$2" == "" ]
then 
echo Missing target directory and dateZ arguments
exit
fi

export UBLversion=2.3
export UBLstage=csprd03

export targetdir=$1
export label=$2
export package=codelists
export UBLversionStage=UBL-$UBLversion-$UBLstage
bash make-UBL-code-lists.sh "$1" "$UBLversion" "$UBLstage" "$2"
