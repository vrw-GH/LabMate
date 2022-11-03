@echo off
cls
REM use %1 = "/I" for "i"nformation
if "%1" == "/i"     main //info //F:50 //DYNF:6 //SWAPK:1024 //SWAPPATH:c:\ TLC
if NOT "%1" == "/i" main //F:50 //DYNF:6 //SWAPK:1024 //SWAPPATH:c:\ TLC
