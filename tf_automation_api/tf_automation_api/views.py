from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .views_functions import saveMakeTfvars, makeTfvars, listResources, deleteByUuid

@api_view(['POST'])
def persistent_resource(request, resource_type):
    tfvar = saveMakeTfvars(request, resource_type)
    if tfvar:
        return HttpResponse(tfvar, status=status.HTTP_201_CREATED)
    else:
        return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def nonp_resource(request, resource_type):
    tfvar = makeTfvars(request, resource_type)
    if tfvar:
        return HttpResponse(tfvar, status=status.HTTP_200_OK)
    else:
        return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def rgkv_list(request):
    rg_list = listResources(request, 'rg')
    kv_list = listResources(request, 'kv')
    output = {'rg': rg_list, 'kv': kv_list}
    return Response(output, status=status.HTTP_200_OK)

@api_view(['POST'])
def rgkv_delete(request):
    deleteByUuid(request, 'rg')
    deleteByUuid(request, 'kv')
    return Response(status=status.HTTP_204_NO_CONTENT)