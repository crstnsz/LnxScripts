#!/bin/sh
$echo date
/opt/rclone/rclone-v1.39-linux-amd64/rclone copy /home/crstnsz/GoogleDrive/CarteirasSenhas/Cristiano.kdbx  onedrive:Backup/;

for arq in /opt/bin/*.*; do 
   /opt/rclone/rclone-v1.39-linux-amd64/rclone copy $arq onedrive:Backup/; 
   $echo date
done
#for arq in /hddvm3/Win10Desenv_`date +%A | tr '[A-Z]' '[a-z]'`.*;  do
for arq in /hddbkp/Win10Desenv_*.*;  do
   /opt/rclone/rclone-v1.39-linux-amd64/rclone copy $arq onedrive:VMDesenv/;
   $echo date
done
#shutdown -h now
