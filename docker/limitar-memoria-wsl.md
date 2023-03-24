#limitar memoria wsl

wsl --shutdown

notepad "$env:USERPROFILE/.wslconfig"

##dentro do arquivo escrever 

```
[wsl2]
memory=8GB
processors=4
```