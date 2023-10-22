@echo off
java -jar "%~dp0xjparse.jar" -c "%~dp0catalog.xml" %* >t:\work\xjparse.err
set xjparse.err=%errorlevel%
if %xjparse.err% NEQ 0 goto :err
del t:\work\xjparse.err
set xjparse.err=
echo No validation errors.
goto :done
:err
type t:\work\xjparse.err
:done
exit /b %xjparse.err%
