init:
	cd ./infra && terraform init

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan -out ../plan.tfplan

deploy:
	cd ./infra && terraform apply -input=false -auto-approve ../plan.tfplan

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
