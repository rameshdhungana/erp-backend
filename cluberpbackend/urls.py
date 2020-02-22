"""cluberpbackend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from django.urls import include, path
from rest_framework_swagger.views import get_swagger_view

schema_view = get_swagger_view(title='API')

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    # url(r'^rest-users/', include('rest_auth.urls')),
    # path('api-users/', include('rest_framework.urls')),
    path('auth/', include('users.urls')),
    path('events/', include('events.urls')),
    path('items/', include('items.urls')),
    path('coupons/', include('coupons.urls')),
    path('orders/', include('orders.urls')),
    path('payments/', include('payments.urls')),
    path('api-list/', schema_view)

]
