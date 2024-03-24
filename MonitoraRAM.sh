#!/bin/bash

: << 'COMMENT'

A finalidade deste script é monitorar o consumo de memoria ram da maquina e caso a quantidade de memoria livre esteja abaixo de 10%, disparar alerta por email 
usando a ferramenta SSMTP já configurada previamente no HOST e posteriormente ser automatizado com o crontab.

Autor: Henrique Rangel de Carvalho Rocha 

COMMENT

#DEFININDO VARIÁVEIS
TOTAL=$(free -m | grep Mem | awk '{print $2}')
MINIMO=$(awk "BEGIN {print int($TOTAL * 0.1)}")
hostname=$(hostname)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

#CRIANDO LOOP QUE FARÁ O MONITORAMENTO
while true
do
	livre=$(free -m | grep Mem | awk '{print $7}')
        if [ $livre -lt $MINIMO ]
        then
		echo "Abaixo do minimo"
                echo -e  "Subject:Memoria $hostname\n\nA memória livre do servidor está abaixo de $MINIMO, por favor verifique!\n\nTimestamp: $timestamp" | ssmtp endereço@dominio.com
                sleep 60
        fi
done


