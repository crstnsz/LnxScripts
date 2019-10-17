#!/bin/sh
$echo date
for arq in /opt/bin/*.*; do 
   /opt/rclone/rclone-v1.39-linux-amd64/rclone copy $arq onedrive:Backup/; 
   $echo date
done
for arq in /hddbkp/Win10Desenv_`date +%A | tr '[A-Z]' '[a-z]'`.*;  do
    $echo  /opt/rclone/rclone-v1.39-linux-amd64/rclone copy $arq onedrive:VMDesenv/`date +%A | tr '[A-Z]' '[a-z]'`/;
#   /opt/rclone/rclone-v1.39-linux-amd64/rclone copy $arq onedrive:VMDesenv/`date +%A | tr '[A-Z]' '[a-z]'`/;
   $echo date
done
