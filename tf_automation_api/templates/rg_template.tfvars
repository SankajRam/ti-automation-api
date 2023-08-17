resource_groups = {
{% for resource_group in rg %} 
    {{ portfolio }}-{{ resource_group.name }}-{{ environment }} = {
        name = "{{ portfolio }}-{{ resource_group.name }}-{{ environment }}"
        {% if resource_group.region != "" %}
        region = "{{ resource_group.region }}" {% endif %}
    }
{% endfor %}  
}