virtual_machines = {
    {% for virtual_machine in vm %}
    {{ virtual_machine.name }} = {
        resource_group_key  = "{{ virtual_machine.resource_group_key }}"
        provision_vm_agent  = true
        os_type             = "{{ virtual_machine.os }}"
        keyvault_key        = "kv1"
        networking_interfaces = {
            {{ virtual_machine.name }} = {
                # Value of the keys from networking.tfvars
                lz_key                        = "{{ virtual_machine.nic_lz_key }}"
                vnet_key                      = "{{ virtual_machine.nic_vnet_key }}"
                subnet_key                    = "{{ virtual_machine.nic_subnet_key }}"
                name                          = "{{ virtual_machine.name }}-nic"
                enable_ip_forwarding          = false
                internal_dns_name_label       = "{{ virtual_machine.name }}"
                {% if virtual_machine.nic_private_ip_address_allocation == "Static" %} 
                private_ip_address_allocation = "{{ virtual_machine.nic_private_ip_address_allocation }}"
                private_ip_address            = "{{ virtual_machine.nic_private_ip_address }}"
                {% endif %}
            }
        }
        virtual_machine_settings = {
            {% filter indent(width=8) %}{% if virtual_machine.os == 'windows' %}{% include "windows.tfvars" %}{% elif virtual_machine.os == 'linux' %}{% include "linux.tfvars" %}{% endif %}{% endfilter %}
        }
        data_disks = {
            data_disk1 = {
                name                 = "{{ virtual_machine.name }}_datadisk1"
                storage_account_type = "Standard_LRS"
                create_option        = "Empty"
                disk_size_gb         = "150"
                lun                  = 1
                zones                = ["1"]
            }
        }
        {% if ((virtual_machine.tags.strip() != "") or (portfolio != "")) %}
        tags = {
            portfolio = "{{ portfolio }}"
            puppet1 = "{{ virtual_machine.puppet_tag }}"
            {% set list1 = virtual_machine.tags.split(';') %}{% for item in list1 %}{% if item != "" %}{% set keyvalue = item.split(':') %}
            {{ keyvalue[0].strip() }} = "{{ (keyvalue[1:]|join(":")).strip() }}"{% endif %}{% endfor %}
        }
        {% endif %}
    }
    {% endfor %}
}