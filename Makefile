init:
	cd ./infra && terraform init -reconfigure

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan

deploy:
	cd ./infra && terraform apply -input=false -auto-approve

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
