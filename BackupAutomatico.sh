#!/bin/bash

: << 'COMMENT'

A finalidade deste script é realizar backup de todo o diretório HOME e enviar o status de backup por email 
usando a ferramenta SSMTP já configurada previamente no HOST e posteriormente ser automatizado com o crontab

Autor: Henrique Rangel de Carvalho Rocha 

COMMENT

#Definindo variáveis e criando o diretório de backup

DIRDEST=/home/backup
BKP=backup_home_$(date +%Y%m%d).tgz 
LOG=/home/backup/LOG/log_backup$(date +%Y%m%d).txt
hostname=$(hostname)


if [ ! -d $DIRDEST ]
then
	mkdir -p $DIRDEST
fi

if [ ! -d /home/backup/LOG ]
then
	mkdir -p /home/backup/LOG
fi

#Realizando o backup, validando com envio por email através da aplicação SSMTP configurada no servidor e registrando LOGS

echo "$(date) - Início do backup semanal" >> $LOG

tar czvpf $DIRDEST/$BKP --exclude="$DIRDEST" /home/* > /dev/null 2>&1

if [ $? -eq 0 ]
then
	echo -e "Subject: Backup\n\nBackup semanal do diretório HOME do host $hostname realizado com sucesso" | ssmtp endereço@dominio.com.br
	echo "$(date) - SUCESSO: Fim do backup semanal" >> $LOG

else
	echo -e "Subject: Backup\n\nBackup semanal não realizado" | ssmtp endereço@dominio.com
	echo "$(date) - ERRO: Backup semanal do diretório HOME do host $hostname não realizado" >> $LOG

fi










