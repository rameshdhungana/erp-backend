from rest_framework import routers

from orders.views import OrderViewSet, OrderedItemViewSet

router = routers.DefaultRouter()
router.register(r'orders', OrderViewSet, base_name='orders')
router.register(r'ordered-items', OrderedItemViewSet, base_name='ordered-items')

urlpatterns = [

]

urlpatterns += router.urls
