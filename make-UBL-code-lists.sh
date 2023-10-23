# Dependencies
#
ant=utilities/ant
saxon=utilities/saxon9he/saxon9he.jar
xjparse=utilities/xjparse/xjparse.jar

if [ ! -e "master-code-list-UBL-$2-$3.xml" ]
then
echo >build.prepare.$label.txt Missing input file: master-code-list-UBL-$2-$3.xml
exit
fi

if [ ! -d $targetdir ]; then mkdir $targetdir ; fi
cp -r . $targetdir/

pushd $targetdir
echo Building packaging script...
java -jar $saxon -xsl:Crane-list2ant.xsl -s:master-code-list-UBL-$2-$3.xml -o:make-code-list.ant.xml "raw-uri-prefix=raw/" "intermediate-uri-prefix=work/" "output-uri-prefix=$3/" "bundle=$package-$UBLversionStage-$label" 2>build.prepare.$label.txt
serverReturn=$?
if [ "$serverReturn" != "0" ]; then exit ; fi

echo Building package...
java -Dant.home=$ant -classpath $xjparse:$ant/lib/ant-launcher.jar:$saxon:. org.apache.tools.ant.launch.Launcher -buildfile make-code-list.ant.xml "-Ddir=$targetdir" "-Dlabel=$label" 2>build.prepare.$label.txt
serverReturn=$?
if [ "$serverReturn" != "0" ]; then exit ; fi

popd
sleep 2
if [ ! -d $targetdir/$package-$UBLversionStage-$label-archive-only/ ]; then mkdir $targetdir/$package-$UBLversionStage-$label-archive-only/ ; fi
cp $targetdir/build.console.$label.txt $targetdir/$package-$UBLversionStage-$label-archive-only/
cp $targetdir/build.prepare.$label.txt $targetdir/$package-$UBLversionStage-$label-archive-only/
echo $serverReturn                    >$targetdir/$package-$UBLversionStage-$label-archive-only/build.exitcode.$label.txt
touch                                  $targetdir/$package-$UBLversionStage-$label-archive-only/build.console.$label.txt

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $targetdir
if [ -f $package-$UBLversionStage-$label-archive-only.zip ]; then rm $package-$UBLversionStage-$label-archive-only.zip ; fi
7z a $package-$UBLversionStage-$label-archive-only.zip $package-$UBLversionStage-$label-archive-only
if [ -f $package-$UBLversionStage-$label.zip ]; then rm $package-$UBLversionStage-$label.zip ; fi
7z a $package-$UBLversionStage-$label.zip $package-$UBLversionStage-$label
popd