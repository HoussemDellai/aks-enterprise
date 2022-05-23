az login

terraform init

terraform plan -out tfplan

# Format tfplan.json file
terraform show -json tfplan | jq '.' > tfplan.json

# show only the changes
cat tfplan.json | jq -r '(.resource_changes[] | [.change.actions[], .type, .change.after.name]) | @tsv'

terraform apply tfplan