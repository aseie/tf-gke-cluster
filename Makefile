init:
	cd ./infra && terraform init

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan -out plan.tfplan

deploy:
	cd ./infra && terraform apply plan.tfplan -input=false -auto-approve

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
