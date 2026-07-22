Para configurar o Linux Mint sem a interface gráfica de forma definitiva, você deve desativar o gerenciador de telas (LightDM) e alterar o alvo de inicialização do sistema para o modo texto. 

No terminal, execute:

```sh
sudo systemctl disable lightdm.service --now
sudo systemctl set-default multi-user.target
```
Se precisar voltar para o modo gráfico, digite 

```sh
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service --now
```