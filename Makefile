prepare-env:
	ansible-galaxy install -r requirements.yml
	cp --update=none group_vars/webservers/vault.yml.example group_vars/webservers/vault.yml
	touch .vault_pas

init:
	ansible-playbook -vv playbook.yml --tags init

init-datadog:
	ansible-playbook playbook.yml --tags init-datadog

start:
	ansible-playbook playbook.yml --tags start

stop:
	ansible-playbook playbook.yml --tags stop

pas-gen:
	@tr -dc 'A-Za-z0-9!@#$?%^&*_=.,:;' < /dev/urandom | head -c 64 | tee .vault_pas > /dev/null 2>&1

pas-enc:
	ansible-vault encrypt group_vars/webservers/vault.yml

pas-edit:
	ansible-vault edit group_vars/webservers/vault.yml

