from rest_framework import routers

from carts.views import ItemCartViewSet

router = routers.DefaultRouter()

router.register(r'carts', ItemCartViewSet, base_name='item-carts')
urlpatterns = [
]

urlpatterns += router.urls
