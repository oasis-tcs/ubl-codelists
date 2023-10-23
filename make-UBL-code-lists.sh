# Dependencies
#
ant=utilities/ant
saxon=utilities/saxon9he/saxon9he.jar
xjparse=utilities/xjparse/xjparse.jar

if [ ! -d $targetdir ]; then mkdir $targetdir ; fi
find . -not -name $targetdir -not -name .git\* -maxdepth 1 -exec cp -r {} $targetdir/ \;

pushd $targetdir

if [ ! -e "master-code-list-UBL-$UBLversion-$UBLstage.xml" ]
then
echo >build.console.$label.txt Missing input file: master-code-list-UBL-$UBLversion-$UBLstage.xml
serverReturn=1
else

echo Building packaging script...
java -jar $saxon -xsl:Crane-list2ant.xsl -s:master-code-list-UBL-$UBLversion-$UBLstage.xml -o:make-code-list.ant.xml "raw-uri-prefix=raw/" "intermediate-uri-prefix=work/" "output-uri-prefix=$UBLstage/" "bundle=$package-$UBLversionStage-$label" 2>build.prepare.$label.txt
serverReturn=$?
if [ "$serverReturn" != "0" ]; then exit ; fi

echo Building package...
java -Dant.home=$ant -classpath $xjparse:$ant/lib/ant-launcher.jar:$saxon:. org.apache.tools.ant.launch.Launcher -buildfile make-code-list.ant.xml "-Ddir=$targetdir" "-Dlabel=$label" 2>build.prepare.$label.txt
serverReturn=$?
if [ "$serverReturn" != "0" ]; then exit ; fi

fi

popd

sleep 2
if [ ! -d $targetdir/$package-$UBLversionStage-$label-archive-only/ ]; then mkdir $targetdir/$package-$UBLversionStage-$label-archive-only/ ; fi
if [ -e $targetdir/build.console.$label.txt ]; then cp $targetdir/build.console.$label.txt $targetdir/$package-$UBLversionStage-$label-archive-only/ ; fi
echo $serverReturn                    >$targetdir/$package-$UBLversionStage-$label-archive-only/build.exitcode.$label.txt
touch                                  $targetdir/$package-$UBLversionStage-$label-archive-only/build.console.$label.txt
