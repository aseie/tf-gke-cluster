init:
	cd ./infra && terraform init

validate:
	cd ./infra && terraform validate

plan:
	cd ./infra && terraform plan -out ${{ github.workspace }}/plan.tfplan

deploy:
	cd ./infra && terraform apply -input=false -auto-approve ${{ github.workspace }}/plan.tfplan

destroy:
	cd ./infra && terraform destroy -input=false -auto-approve
