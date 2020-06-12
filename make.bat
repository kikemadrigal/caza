@echo off
rem //Inicialización
set nombreDSK=main.dsk

rem // Diskmanager: nos permite manegar imagenes de disco que contienen archivos binarios o texto ASCII
rem Añadiendo archivos al .dsk, tenemos que crear antes el archivo main.dsk con el programa disk manager
rem para ver los comandos abrir archivo DISKMGR.chm

rem AUTOEXEC.BAS es un archivo basic con el comando bload que hará que se autoejecute el main.bas
start /wait tools/Disk-Manager\DISKMGR.exe -A -F -C %nombreDSK% AUTOEXEC.BAS
rem rem main.bas contiene mi código fuente
start /wait tools/Disk-Manager\DISKMGR.exe -A -F -C %nombreDSK% main.bas
start /wait tools/Disk-Manager\DISKMGR.exe -A -F -C %nombreDSK% assets/PAISAJE2.SC5

rem // Abriendo el emulador
rem Abriendo con FMSX https://fms.komkon.org/fMSX/fMSX.html en hardware->Model->Elige MSX1, parece el más rápido
rem start /wait emulators/fMSX/fMSX.exe -diska %nombreDSK%
rem Abriendo con blueMSX http://www.msxblue.com/manual/dskfaq.htm  comand line:http://www.msxblue.com/manual/commandlineargs_c.htm
rem start /wait emulators/BlueMSX/blueMSX.exe -machine "MSX2 - Spanish" -dira %nombreDSK%
rem Abriendo con openmsx, presiona f9 al arrancar para que vaya rápido
start /wait emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska %nombreDSK% 





