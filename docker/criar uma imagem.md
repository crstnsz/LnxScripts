
# Salvar as alteraçõs do container em uma imagem
docker commit <container id> <nome_da_sua_imagem>

# trocar o nome da imagem para subir no serviço 
docker tag <nome_da_sua_imagem> <registry><nome_da_sua_imagem>

#subir a nova imagem 
docker push username/meu-nginx:1.0
