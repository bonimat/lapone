# Readme
Il progetto contiene un docker-compose per lo sviluppo di applicazione 
php su uno stack così composto: 
- Linux (ubuntu) 
- PHP-fpm 
- Apache2
- Postgres

Una volta avviato il progetto con 
```
docker-compose up -d --build
```
all'indirizzo:

http://localhost:8040/info.php

si dovrebbe visualizzare il phpinfo del sistema.

## Servizi
Il docker-compose è diviso in 3 oggetti: due servizi e un volume.
Il primo servizio si chiama **lapone** (Linux-Apache2-Php7.4-1) costruito sul container lapone7.4 e contiene Apache2 2.4 + php-fpm 7.4 a altri strumenti di sviluppo.

Il secondo servizio è chiamato **dblapone** ed è il container dblapone7.4 con Postgres 13.

Il terzo elemento è un volume persistente interno chiamato **data_lapone** per mantenere i dati del database Postgres.

Nota: i comandi docker-compose richiamano i nomi dei servizi e non i nomi dei container. Gli stessi nomi sono utilizzati nella rete interna come hostname per la comunicazione da un oggetto all'altro. *Quindi **lapone** vede il database su un hostname chiamato **dblapone**.*


### PHP
La versione del php-fpm è la 7.4, per l'uso di cakePHP 3 (https://github.com/webdevops 
simile a quella usata su blog di CakeDC https://www.cakedc.com/rochamarcelo/2020/07/20/a-quick-cakephp-local-environment-with-docker).

Nel container sono installati:
- PHPUnit 7.5.20
- Composer version 2.0.14
- Xdebug Version	3.0.4 (ip host 172.18.0.1 porta 9004)

Il codice php è trasferito dalla cartella del docker-compose sulla cartella di lapone **/app** che è vista dal serverweb come **DocumentRoot**.

### Postgres
La versione del DB è PostgreSQL 13.3 (Debian 13.3-1.pgdg100+1) ma dipende dal momento della creazione del progetto.  
```
docker-compose exec dblapone postgres -V 
```
Al db si accede con le credenziali
```
username: admin
password: password
```
e l'accesso dall'host è permesso con un redirect sulla porta **5433**

Per impostazioni di default il db mantiene i dati permanentemente in un volume **<cartella>_data_lapone** . Spegnere(stop) i container non è sufficiente a rimuoverlo. Un modo per tutto è (container, rete e volumi)
```
docker-compose down --volumes 
```
o 
```
docker-compose down -v
```
### Volume
I nomi dei volumi sono composti dalla cartella in cui appartiene il docker-compose e il nome specificato nel docker-compose uniti da un '_'.

Per visualizzare i volumi
```
docker volume ls
```
per rimuovere il volume specifico
```
docker volume rm <nome_volume>
```
es.:
```
docker volume rm myapp_data_lapone
```
### Comunicazione dei servizi
Il server web **lapone** puo' accedere al database **dblapone** utilizzando i seguenti parametri:

```
hostname: dblapone
port: 5432
username: admin
password: password
```
Nel caso si siano configurati username e password diversi tramite file .env, è necessario utilizzare quelli. 

### .Env

Dal file env.example è possibile ricavare un file .env in cui personalizzare alcuni paramentri come 

- WEBPORT= porta di ascolto per il webserver. Default 8040
- DBUSER= username di amministrazione del database. Default admin
- DBPASS= password di amministrazione del database. Default password
- DBPORT= porta di ridirezione del servizio del database. Default 5433
- PREFIX_CONTAINER= prefisso dei container del progetto. Default nessuno.

Dichiarare solo le variabili che interessano. Per le altre il sistema utilizzerà i valori di default.

### Comandi
Avvio sistema e rigenerazione dei container
```
docker-compose up -d --build
```
Spegnimento
```
docker-compose stop
```
Cancellazione dei container e del volume
```
docker-compose down -v
```
Controllo dei log
```
docker-compose logs -f
```
Controllo dei log per il container 
```
docker-compose logs -f lapone
```
Accesso al dbpsql
```
docker-compose exec dblapone psql -U admin postgres
```
Accesso alla webserver
```
docker-compose exec lapone /bin/bash
```

### Suggerimenti
#### Alias:
Nella proprio bash si possono aggiungere i seguenti alias
```
alias lapp1-php="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) lapone php"
alias lapp1-composer="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) lapone composer"
```
si potrebbe aggiungere anche 
```
alias lapp1-cake="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) lapone bin/cake"

``` 