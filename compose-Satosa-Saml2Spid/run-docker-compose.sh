#!/bin/bash

function create-volume {
	if [ ! "$(docker volume ls -q -f name=$1)" ]
	then
	    echo -e "Il volume $1 non esiste, lo creo! \n"
	    docker volume create --name=$1
	    echo -e "\n"
	    if [[ ! -z "$2" ]]
	    then 
	       echo -e "Ho creato il volume e ci copio i dati da $2 \n"
	       sudo cp -R $2* `docker volume inspect $1 | jq .[0].Mountpoint | sed 's/"//g'`
	    fi   
	else
	    echo -e "Il volume $1 esiste, non faccio nulla! \n"  
	fi
}

create-volume satosa-saml2spid_metadata ../example/metadata/
create-volume satosa-saml2spid_certs ../example/pki/
create-volume satosa-saml2spid_static ../example/static/
create-volume satosa-saml2spid_nginx_certs nginx/certs/
create-volume satosa-saml2spid_mongodata 

echo -e "\n"

echo -e "Provo a scaricare le nuove versioni. \n"

docker-compose -f docker-compose.yml pull

echo -e "\n"

echo -e "Provo a fare il down della composizione. \n"

docker-compose -f docker-compose.yml down -v

echo -e "\n"

echo -e "Tiro su la composizione, in caso, con le nuove versioni delle immagini. \n"

docker-compose -f docker-compose.yml up -d

echo -e "\n"

echo -e "Ho Completato! \n"
echo -e "Se volete vedere il log live potete lanciare il comando: 'docker-compose -f docker-compose.yml logs -f' \n"

exit 0
