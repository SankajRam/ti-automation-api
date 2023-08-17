{% block os %}{{ virtual_machine.os }} = {
        name                            = "{{ virtual_machine.name }}"
        size                            = "{{ virtual_machine.size }}"
        zone                            = "{{ virtual_machine.zone }}"
        admin_username                  = "{{ virtual_machine.admin_username }}"
        admin_ssh_keys = {
            admin = {
                lz_key       = "{{ virtual_machine.admin_lz_key }}"
                keyvault_key = "{{ virtual_machine.admin_keyvault_key }}"
                secret_name  = "{{ virtual_machine.admin_secret_name }}"
            }
        }
        disable_password_authentication = true
        identity = {
            type = "SystemAssigned"
        }
        # Value of the nic keys to attach the VM. The first one in the list is the default nic
        network_interface_keys = ["{{ virtual_machine.name }}"]
        os_disk = {
            name                 = "{{ virtual_machine.name }}-os"
            caching              = "ReadWrite"
            storage_account_type = "Standard_LRS"

            disk_encryption_set_key = "set1"
            # lz_key = "" # for remote disk_encryption_set
        }
        source_image_reference = {
            publisher   = "{{ virtual_machine.os_publisher }}"
            offer       = "{{ virtual_machine.os_offer }}"
            sku         = "{{ virtual_machine.os_sku }}"
            version     = "{{ virtual_machine.os_version }}"
        }
    }{% endblock %}