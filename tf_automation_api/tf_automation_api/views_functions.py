from .models import ResourceGroup, KeyVault
from .serializers import getSerializer
from .generate_tfvars import generateTfvars

"""
Custom exceptions for Serializer validation & resource_type validation
"""
class ValidationError(Exception):...
class ResourceTypeError(Exception):...

PERSISTENT_RESOURCES = [
    'rg',
    'kv'
]


def saveResource(uuid, data, resource_type, portfolio, environment):
    """
    Save the resources to the database.

    Args:
        uuid (str): The UUID of the client.
        data (list): List of dictionaries representing the resources.
        resource_type (str): The type of the resources.

    Raises:
        ValidationError: If there is a validation error while saving the resources.
    """
    for item in data:
        item["uuid"] = uuid
        itemSerializer = getSerializer(resource_type)
        serializer = itemSerializer(data=item)
        if serializer.is_valid():
            existing = itemSerializer.get_existing(item['name'],uuid)
            if existing:
                serializer = itemSerializer(existing, data=item)
            if serializer.is_valid():
                serializer.save()
            else:
                raise ValidationError
        else:
            raise ValidationError
    return

def saveMakeTfvars(request, resource_type):
    """
    Save resources and returns generated tfvars.

    Args:
        request (HttpRequest): The HTTP request object.
        resource_type (str): The type of the resources.

    Returns:
        str: The generated tfvars.

    Raises:
        ValueError: If UUID and data are not provided in the request.
    """
    if resource_type in PERSISTENT_RESOURCES:
        data = request.data.get('data', [])
        uuid = request.data.get('uuid')
        portfolio = request.data.get('portfolio')
        environment = request.data.get('environment')
        if uuid and data:
            saveResource(uuid, data, resource_type, portfolio, environment)
            return generateTfvars({f'{resource_type}':data, 'portfolio': portfolio, 'environment': environment}, resource_type)
        else:
            raise ValueError
    else:
        return ResourceTypeError


def makeTfvars(request, resource_type):
    """
    Generate tfvars based on the request data.

    Args:
        request (HttpRequest): The HTTP request object.
        resource_type (str): The type of the resources.

    Returns:
        str: The generated tfvars.

    Raises:
        ValueError: If data is not provided in the request.
    """
    data = request.data.get('data', [])
    portfolio = request.data.get('portfolio')
    environment = request.data.get('environment')
    if data:
        return generateTfvars({f'{resource_type}':data, 'portfolio': portfolio, 'environment': environment}, resource_type)
    else:
        raise ValueError

def getResourceList(uuid, resource_type):
    """
    Get a list of resources based on UUID and resource type.

    Args:
        uuid (str): The UUID of the client.
        resource_type (str): The type of the resources.

    Returns:
        QuerySet: A queryset containing the filtered resources.

    Raises:
        ResourceTypeError: If the resource type is not supported.
    """
    match(resource_type):
        case 'rg':
            return ResourceGroup.objects.filter(uuid=uuid)
        case 'kv':
            return KeyVault.objects.filter(uuid=uuid)
        case other:
            raise ResourceTypeError

def listResources(request, resource_type):
    """
    List the names of resources based on the request data.

    Args:
        request (HttpRequest): The HTTP request object.
        resource_type (str): The type of the resources.

    Returns:
        list: A list of resource names.

    Raises:
        ValueError: If UUID is not provided in the request.
    """
    uuid = request.data.get('uuid', str())
    data = getResourceList(uuid, resource_type)
    itemSerializer = getSerializer(resource_type)
    serializer = itemSerializer(data, many=True)
    itemData = serializer.data
    itemList = []
    for item in itemData:
        itemList.append(item['name'])
    return itemList

def deleteByUuid(request, resource_type):
    """
    Delete resources based on the UUID and resource type.

    Args:
        request (HttpRequest): The HTTP request object.
        resource_type (str): The type of the resources.

    Raises:
        ResourceTypeError: If the resource type is not supported.
    """
    uuid = request.data.get('uuid', str())
    match resource_type:
        case 'rg':
            ResourceGroup.objects.filter(uuid=uuid).delete()
        case 'kv':
            KeyVault.objects.filter(uuid=uuid).delete()
        case other:
            raise ResourceTypeError
    return