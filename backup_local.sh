qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock 
VBoxManage controlvm "Oracle 12C" savestate
VBoxManage controlvm "Desenvolvimento" savestate
rm -f /hddbkp/Win10Desenv_`date +%A | tr '[A-Z]' '[a-z]'`.7z.*
7z a -v5G /hddbkp/Win10Desenv_`date +%A | tr '[A-Z]' '[a-z]'`.7z /ssdvm2/Win10Desenv/*.*
#shutdown -h now
