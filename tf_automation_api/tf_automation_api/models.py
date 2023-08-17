from django.db import models

class ResourceGroup(models.Model):
    uuid = models.CharField(max_length=255)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.uuid + " | " + self.name

class KeyVault(models.Model):
    uuid = models.CharField(max_length=255)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.uuid + " | " + self.name
        