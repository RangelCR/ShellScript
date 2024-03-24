#!/bin/bash

: << 'COMMENT'

A finalidade deste script é monitorar o consumo da partição principal do disco (/)
e enviar um alerta via email a cada 5 minutos caso o consumo esteja acima de 90%, usando a ferramenta SSMTP para o envio do alerta via email 
já configurada previamente no HOST e posteriormente ser automatizado com o crontab.
Autor: Henrique Rangel de Carvalho Rocha 

COMMENT

HOSTNAME=$(hostname)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

while true
do
    CONSUMO=$(df -h | grep '/$' | awk '{print $5}' | cut -d'%' -f1)
    if [ $CONSUMO -ge 20 ]; then
	echo -e  "Subject:Armazenamento $HOSTNAME\n\nO espaço livre em disco está abaixo de 10%, por favor verifique com urgência!\n\nTimestamp: $timestamp" | ssmtp endereço@dominio.com
    fi
    sleep 5 
done



