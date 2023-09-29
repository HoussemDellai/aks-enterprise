ForEach ($resource_id in $(az resource list --query [].id -o tsv)) {
    
    $diag_settings = $(az monitor diagnostic-settings list --resource $resource_id)

    If ($diag_settings -ne $null) {  

        $diag_settings_name = $diag_settings[0].name

        echo "Deleting Diagnostic Settings $diag_settings_name for $resource_id ..."

        az monitor diagnostic-settings delete -n $diag_settings_name --resource $resource_id
    }
}