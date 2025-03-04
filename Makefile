prepare-env:
	ansible-galaxy install -r requirements.yml
	cp --update=none group_vars/webservers/vault.yml.example group_vars/webservers/vault.yml
	touch .vault_pas

init:
	ansible-playbook playbook.yml --tags init --vault-password-file .vault_pas

init-datadog:
	ansible-playbook playbook.yml --tags init-datadog --vault-password-file .vault_pas

start:
	ansible-playbook -l webservers playbook.yml --tags start --vault-password-file .vault_pas

stop:
	ansible-playbook -l webservers playbook.yml --tags stop --vault-password-file .vault_pas

pas-gen:
	@tr -dc 'A-Za-z0-9!@#$?%^&*_=.,:;' < /dev/urandom | head -c 64 | tee .vault_pas > /dev/null 2>&1

pas-enc:
	ansible-vault encrypt group_vars/webservers/vault.yml --vault-password-file .vault_pas

pas-edit:
	ansible-vault edit group_vars/webservers/vault.yml --vault-password-file .vault_pas

