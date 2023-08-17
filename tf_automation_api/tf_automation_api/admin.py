from django.contrib import admin
from .models import ResourceGroup, KeyVault

admin.site.register(ResourceGroup)
admin.site.register(KeyVault)