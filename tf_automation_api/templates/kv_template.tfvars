{% for keyvault in kv %}
keyvaults = { 
  kv1 = {
    name                        = "{{ portfolio }}-{{ keyvault.name }}-{{ environment }}"
    resource_group_key          = "{{ keyvault.resource_group_key }}"
    sku_name                    = "{{ keyvault.sku_name }}"
    soft_delete_enabled         = false #keep false while testing
    purge_protection_enabled    = false #keep false while testing
    enabled_for_disk_encryption = true
    creation_policies           = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
        key_permissions    = ["Decrypt", "Encrypt", "Sign", "UnwrapKey", "Verify", "WrapKey", "List", "Get", "Create", "Purge"]
      }
      msi_user_level3 = {
        # This is the level3.msi object_id
        object_id          = "90fcb516-2b2d-4163-be38-2da65c471927"
        secret_permissions = [
          "Delete", "Get", "List", "Purge", "Set", "Recover"
        ]
      }      
      disk_encryption_sets = {
        disk_encryption_set_key = "set1"
       # lz_key = "example" # for remote disk_encryption_set
        key_permissions = ["Decrypt", "Encrypt", "Sign", "UnwrapKey", "Verify", "WrapKey", "List", "Get", "Create", "Purge"]
      }    
    }
    network = {
      bypass = "AzureServices"
      default_action = "Deny"
      ip_rules       = ["165.225.112.0/23","165.225.230.0/23"]
      subnets = {

        build_dev_subnet = {
          lz_key   = "singtel-git-core-build-level2-dev-sea-01"
          vnet_key = "build_vnet2"
          subnet_key = "tier2_build_vnet2"
        }
      }
    }
  }
}

keyvault_keys = {
  disk-key = {
    keyvault_key       = "kv1"
    resource_group_key = "{{ keyvault.resource_group_key }}"
    name               = "disk-key"
    key_type           = "RSA"
    key_size           = 2048
    key_opts           = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

    # curve = ""
    # not_before_date = ""
    # expiration_date = ""
  }
}

# Store output attributes into keyvault secret
dynamic_keyvault_secrets = { 
  kv1 = {
    vm-admin-username = {
      secret_name = "vm-admin-username"
      value       = "winadmin"
    }
    vm-admin-password = {
      secret_name = "vm-admin-password"
      value       = "dynamic"
      config = {
        length           = 25
        special          = true
        override_special = "_!@"
      }
    }
  } 
}

disk_encryption_sets = {
  set1 = {
    name               = "diskencryptset1"
    resource_group_key = "{{ keyvault.resource_group_key }}"
    # keyvault_key = {  # If in case of remote Kevault Key
    #   lz_key = ""
    # }
    key_vault_key_key = "disk-key"
    keyvault = {
      # lz_key = "" # if in case of remote Keyvault
      key = "kv1"
    }
  }
}

{% endfor %} 