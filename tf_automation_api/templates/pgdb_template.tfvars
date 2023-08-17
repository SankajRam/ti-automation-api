postgresql_flexible_servers = {
{% for instance in pgdb %}
  {{ portfolio }}-{{ instance.name }}-{{ environment }} = {
    name       = "{{ portfolio }}-{{ instance.name }}-{{ environment }}"
    region     = "{{ instance.region }}"
    version    = "{{ instance.version }}"
    sku_name   = "{{ instance.sku_name }}"
    storage_mb = "{{ instance.storage_mb }}"
    zone       = "{{ instance.zone }}"
	
    resource_group = {
      key = "{{ instance.resource_group_key }}"
    }
     keyvault = {
       key = "kv1" 
     }

    postgresql_configurations = {
      backslash_quote = {
        name  = "backslash_quote"
        value = "on"
      }
      bgwriter_delay = {
        name  = "bgwriter_delay"
        value = "25"
      }
    }

    vnet = {
      key         = "{{ instance.vnet_key }}"
      subnet_key  = "{{ instance.vnet_subnet_key }}"
      lz_key      = "{{ instance.vnet_lz_key }}"
    }	

    private_dns_zone = {
      key         = "{{ instance.private_dns_zone_key }}"
      lz_key      = "{{ instance.private_dns_zone_lz_key }}"
    }


    postgresql_databases = {
      {{ instance.db_name }} = {
        name = "{{ instance.db_name }}"
      }
    }
  }
{% endfor %}
}
