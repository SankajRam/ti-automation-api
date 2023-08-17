from rest_framework import serializers
from .models import ResourceGroup, KeyVault

def getSerializer(resource_type):
    match(resource_type):
        case 'rg':
            return rgSerializer
        case 'kv':
            return kvSerializer

class rgSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResourceGroup
        fields = ['name','uuid']
        unique_together = ['name', 'uuid']

    @staticmethod
    def get_existing(name, uuid):
        try:
            existing_rg = ResourceGroup.objects.get(name=name, uuid=uuid)
            return existing_rg
        except ResourceGroup.DoesNotExist:
            return None
                  
class kvSerializer(serializers.ModelSerializer):
    class Meta:
        model = KeyVault
        fields = ['name','uuid']
        unique_together = ['name', 'uuid']

    @staticmethod
    def get_existing(name, uuid):
        try:
            existing = KeyVault.objects.get(name=name, uuid=uuid)
            return existing
        except KeyVault.DoesNotExist:
            return None