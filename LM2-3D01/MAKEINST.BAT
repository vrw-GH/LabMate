echo off
cls
if "%1" == "" goto usage
erase %1.ex_
erase lm2000.exe
erase lm2000.zip
cls
pkzip lm2000 lm2.bat main.exe
zip2exe lm2000
ren lm2000.exe %1.ex_
cls
echo made %1.ex_
goto end
:usage
echo Makeinst XXX
:end
