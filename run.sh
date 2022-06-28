#!/bin/bash

echo "Executando arquivo"
echo "Subindo o banco de dados em um container"
docker-compose "-f docker-compose.yml"
sleep "10"
echo "Subindo a API"
docker-compose "-f docker-compose_api.yml"
sleep "3"
echo "Tudo pronto"
