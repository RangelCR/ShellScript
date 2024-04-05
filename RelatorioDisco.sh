#!/bin/bash

: << 'COMMENT'

A finalidade deste script é gerar um relatório semanal em HTML sobre o status de cada partição prinicipal dos discos do HOST.
Enviar o arquivo HTML de saída por email usando a ferramenta MAIL previamente configurada no HOST.
Autor: Henrique Rangel de Carvalho Rocha 

COMMENT

#Criando a função que irá extrair os dados de cada partição e popular a "DIV" que será incorporada ao código HTML.
MONITORA(){
	html_out=""
	DISCOS=$(df -h -x tmpfs -x devtmpfs | tail -n +2)
	IFS=$'\n' 
	for line in $DISCOS; 
	
	do
    	    disco=$(echo "$line" | awk '{print $1}')
        	tamanho=$(echo "$line" | awk '{print $2}')
        	usado=$(echo "$line" | awk '{print $3}')
        	disponivel=$(echo "$line" | awk '{print $4}')
        	porcent_usado=$(echo "$line" | awk '{print $5}')
        	montagem=$(echo "$line" | awk '{print $6}')
    	
	html_out+="	
	<div class="disk-info">
    		<p>Disco: $disco <span id="used-space"></span></p>
	    	<p>Tamanho total: $tamanho<span id="free-space"></span></p>
    		<p>Espaço Usado: $usado<span id="total-space"></span></p>
		<p>Espaço Disponível: $disponivel <span id="used-space"></span></p>
		<p>Porcentagem Utilizada: $porcent_usado <span id="used-space"></span></p>
		<p>Ponto de montagem: $montagem<span id="used-space"></span></p>
	</div>"	
	done	    
	echo "$html_out"	

}

#Definição de variáveis usadas no corpo do HTML.
saida=$(MONITORA)
host=$(hostname)
data=$(date +%d-%m-%Y)



#Criação da base HTML.
cat << eof > Relatório_Disco_Semanal.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Relatório de Discos</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f9f9f9; /* Cor de fundo para o corpo da página */
}

header, footer {
    background-color: #1a237e; /* Azul escuro */
    color: white; /* Cor do texto */
    padding: 20px 0;
    text-align: center;
}

footer {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
}

.disk-info {
    width: 400px; /* Largura aumentada */
    margin: 50px auto;
    padding: 20px;
    border-radius: 5px;
    background-color: #f9f9f9;
    text-align: center;
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2); /* Sombra mais expressiva */
}

.disk-info h3 {
    margin-top: 0;
    font-size: 1.5em;
}

.disk-info p {
    margin: 10px 0;
}

.disk-info span {
    font-weight: bold;
}
</style>
</head>
<body>
<header>
    <h1>Relatório Semanal de Discos - Host: $host - $data <?php echo gethostname(); ?></h1>
</header>
$saida
<footer>
    <p>Autor: Henrique Rangel</p>
</footer>
</body>
</html>
eof


#Faz o envio do email com o relatório em anexo
destinatario="endereço@dominio.com.br"
assunto="Relatório de Discos Semanal"
corpo="Segue em anexo o relatório HTML semanal do estado dos discos do HOST:$host"
arquivo_anexo="./Relatorio_Disco_Semanal.html"

if mail -a "Content-Type: text/html" -s "$assunto" "$destinatario" < "$arquivo_anexo"; then
    echo "E-mail enviado com sucesso."
else
    echo "Falha ao enviar o e-mail."
fi










