{% block os %}{{ virtual_machine.os }} = {
        name                            = "{{ virtual_machine.name }}"
        size                            = "{{ virtual_machine.size }}"
        zone                            = "{{ virtual_machine.zone }}"
        admin_username_key              = "vm-admin-username"
        admin_password_key              = "vm-admin-password"
        delete_os_disk_on_termination   = true
        delete_data_disk_on_termination = true
        license_type                    = "{{ virtual_machine.license_type }}"
        timezone                        = "Singapore Standard Time"
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