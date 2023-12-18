dev:
    @rm -rf .terraform
    @terraform init
    @terraform apply -var-file=env-dev/main.tfvars
prod:
    @rm -rf .terraform
    @terraform init
    @terraform apply -var-file=env-prod/main.tfvars