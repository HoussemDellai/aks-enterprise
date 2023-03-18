ForEach($flow_log in $(az network watcher flow-log list --location westeurop --query [*].name -o tsv))
    {
        echo "Deleting NSG Flow Log $flow_log ..."
        az network watcher flow-log delete --location westeurope -n $flow_log
    }