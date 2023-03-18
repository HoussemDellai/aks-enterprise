ForEach($resource_id in $(az resource list --query [].id -o tsv))
    {
        echo "Deleting Diagnostic Settings for $resource_id ..."
        az monitor diagnostic-settings delete -n diagnostic-settings --resource $resource_id
    }