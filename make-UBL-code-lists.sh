# Dependencies
#
ant=utilities/ant
saxon=utilities/saxon9he/saxon9he.jar
xjparse=utilities/xjparse/xjparse.jar

if [ "$4" == "" ]
then 
echo Missing UBL version, UBL stage, dateZ and date arguments
exit
fi

if [ ! -e "master-code-list-UBL-$1-$2.xml" ]
then
echo Missing input file: master-code-list-UBL-$1-$2.xml
exit
fi

java -jar $saxon -xsl:Crane-list2ant.xsl -s:master-code-list-UBL-$1-$2.xml -o:make-code-list.ant.xml "raw-uri-prefix=raw/" "intermediate-uri-prefix=work/" "output-uri-prefix=$2/"

if [ "$?" != "0" ]; then exit ; fi

echo Building packager...
java -Dant.home=$ant -classpath $xjparse:$ant/lib/ant-launcher.jar:$saxon:. org.apache.tools.ant.launch.Launcher -buildfile make-code-list.ant.xml

if [ "$?" != "0" ]; then exit ; fi

echo Packaging package...
java -Dant.home=$ant -classpath $ant/lib/ant-launcher.jar:$saxon:. org.apache.tools.ant.launch.Launcher -buildfile package-UBL-distribution.xml -Ddir=results/ -Dstage=$2 -Dversion=$3 -Ddatetimelocal=$4 -DUBL=$1

b
b
