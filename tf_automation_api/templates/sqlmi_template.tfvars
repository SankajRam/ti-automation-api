mssql_managed_instances = {
{% for instance in sqlmi %}
  {{ portfolio }}-{{ instance.sqlmi_name }}-{{ environment }} = {
    resource_group_key = "{{ instance.resource_group_key }}"     #RGKEY
    name               = "{{ portfolio }}-{{ instance.sqlmi_name }}-{{ environment }}"            #SQLMI Name
    sku                = {
      name = "{{ instance.sku_name }}"                           #SKU Name
    }
    administratorLogin = "{{ instance.sqlmi_admin_login }}"      #ADMINLOGIN
    # administratorLoginPassword = "@dm1nu53r@30102020"

    //networking
    networking = {
      lz_key     = "{{ instance.network_lz_key }}"       #Level2 LandingZone Key
      vnet_key   = "{{ instance.network_vnet_key }}"     #Level2 Vnet Key
      subnet_key = "{{ instance.network_subnet_key }}"   #Level2 Subnet Key
    }
    keyvault = {
      #lz_key = "caf_auditsub_dev"  #KV Landing Zone KEY (Ignore if KV is in same repo)
      key    = "kv1"       #KV Key
    }

    storageSizeInGB                  = {{ instance.size }}           #RAM
    vCores                           = {{ instance.vcores }}         #VPC
    proxyOverride                    = "Redirect"
    requestedBackupStorageRedundancy = "Local"
    licenseType                      = "BasePrice"
    timezoneId                       = "Singapore Standard Time"
  }
{% endfor %}
}

mssql_managed_databases = {
{% for instance in sqlmi %}
  {{ instance.database_name }} = {
    resource_group_key = "{{ instance.resource_group_key }}"    #RGKEY                    
    name               = "{{ instance.database_name}}"          #SQLMI Instance Name
    mi_server_key      = "{{ instance.sqlmi_name }}"           #SQLI MI Server Key
  }
{% endfor %}
}