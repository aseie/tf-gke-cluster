init:
	cd ./infra && terraform init

fmt:
	cd ./infra && terraform fmt

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan -out ${GITHUB_WORKSPACE}/plan.tfplan

deploy:
	cd ./infra && terraform apply -input=false -auto-approve ${GITHUB_WORKSPACE}/plan.tfplan

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
