# Example for Hexlet DevOps course

### Hexlet tests and linter status:
[![Actions Status](https://github.com/isas2/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/isas2/devops-for-programmers-project-76/actions)

## Requirements

* python3
* ansible

## Quick start

1. Clone repository: `git clone https://github.com/isas2/devops-for-programmers-project-76.git`
2. `cd devops-for-programmers-project-76`
3. Prepare environment: `make prepare-env`
4. Put your password for ansible-vault to a file .vault_pas or generate a new password with: `make gen-pas`
5. Save your DB password, Redmine secret and DataDog API key in group_vars/webservers/vault.yml
6. Encrypt DB password with ansible-vault: `make pas-enc`. For edit encrypted data use: `make pas-edit`
7. Prepare your ansible inventory file: write webserver hostnames or IPs to inventory.ini
8. Setup necessary packages on target hosts: `make init`
9. Start application: `make start`. Use `make stop` to stop it.

## Commands

- `make prepare-env` installing the required ansible roles and collections, create .env file, create vault files;
- `make init` full initialize target hosts;
- `make init-datadog` initialize only DataDog agents on webservers;
- `make start` starts the Redmine application;
- `make stop` stop application;
- `make pas-gen` generate new ansible-vault password;
- `make pas-enc` encrypt vault.yml with ansible-vault;
- `make pas-edit` edit encrypted vault.yml file;

## Deployed application

htps://redmine.zabedu.ru

## Used app docker image

https://hub.docker.com/_/redmine

## Test Redmine start with local DB in docker

```
docker network create -d bridge redmine-network
docker run -d --name redmine-postgres --network redmine-network -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=redmine postgres
docker run -p 80:3000 -d --name some-redmine --network redmine-network -e REDMINE_DB_POSTGRES=redmine-postgres -e REDMINE_DB_USERNAME=redmine -e REDMINE_DB_PASSWORD=secret redmine
```

## Example of nginx reverse proxy configuration

```
upstream redmine {
       server 192.168.100.40:80;
       server 192.168.100.41:80;
}

server {
        listen  80;
        server_name redmine.zabedu.ru;
        location / {
            return 301 https://$server_name$request_uri;
        }
}

server {
        listen 443 ssl;
        server_name redmine.zabedu.ru;
        include /etc/nginx/letsencrypt.conf;
        location / {
                proxy_pass http://redmine;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-Host $server_name;
                proxy_set_header X-Forwarded-Proto $scheme;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
                root   /usr/share/nginx/html;
        }
}
```