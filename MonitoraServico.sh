: << 'COMMENT'

A finalidade deste script é monitorar serviços de aplicações (como no exemplo apache2), reiniciá-los em caso de inatividade, disparar alerta por email 
usando a ferramenta SSMTP já configurada previamente no HOST e posteriormente ser automatizado com o crontab.

Autor: Henrique Rangel de Carvalho Rocha 

COMMENT


#DEFININDO VARIÁVEIS
hostname=$(hostname)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

#CRIANDO LOOP QUE FARÁ O MONITORAMENTO
while true
do
STATUS=$(systemctl is-active apache2)

if [ $STATUS  != active ]
then 
	sudo systemctl start apache2
	sleep 20
	STATUS=$(systemctl is-active apache2)
	if [ $STATUS  == active ]
	then
		 echo -e  "Subject:Apache2 $hostname \n\nO serviço do apache2 estava interrompido e já foi reiniciado automaticamente, por favor verifique a causa da interrupção para evitar novas indisponibilidades\n\nTimestamp: $timestamp"
	else
		 
		 echo -e  "Subject:Apache2 $hostname \n\nO serviço do apache2 está interrompido e não foi possível reiniciá-lo automaticamente, por favor verifique com urgencia!\n\nTimestamp: $timestamp"

	fi
fi


done