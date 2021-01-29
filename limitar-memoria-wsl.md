#limitar memoria wsl


wsl --shutdown

notepad "$env:USERPROFILE/.wslconfig"


##dentro do arquivo escrever 

```
[ws12]
memory=8GB
processors=4
```