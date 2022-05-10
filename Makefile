init:
	cd ./infra && terraform init

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan -out ./infra/plan.tfplan

deploy:
	cd ./infra && terraform apply -input=false -auto-approve ./infra/plan.tfplan

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
