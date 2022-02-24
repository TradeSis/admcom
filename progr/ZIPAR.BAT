@echo off
l:
cd \export\cpd02
del cpd02.zip
pkzip cpd02.zip *.d versao.zip  *.txt *.p *.bat
del *.d 
rem del versao.zip 
copy cpd02.zip c:\transm\export

@echo off
l:
cd \export\cpd16
del cpd16.zip
pkzip cpd16.zip *.d versao.zip *.txt *.p *.bat
del *.d 
rem del versao.zip 
copy cpd16.zip c:\transm\export

@echo off
l:
cd \export\cpd20
del cpd20.zip
pkzip cpd20.zip *.d versao.zip *.txt *.p *.bat
del *.d 
rem del versao.zip 
copy cpd20.zip c:\transm\export

@echo off
l:
cd \export\cpd24
del cpd24.zip
pkzip cpd24.zip *.d versao.zip *.txt *.p *.bat
del *.d 
rem del versao.zip 
copy cpd24.zip c:\transm\export
cd..

copy c:\transm\export\*.zip g:\cpd
