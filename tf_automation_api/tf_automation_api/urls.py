"""
URL configuration for tf_automation_api project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from tf_automation_api import views
import os

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv("DEBUG", 'False').lower() in ('true', '1', 't')

urlpatterns = [
    #path('save-resource/<str:resource_type>/', views.persistent_resource),
    path('make-resource/<str:resource_type>/', views.nonp_resource),
    #path('rgkv/', views.rgkv_list),
    path('end-session/', views.rgkv_delete)
]

if DEBUG:
    urlpatterns += [
        path('admin/', admin.site.urls),
]
