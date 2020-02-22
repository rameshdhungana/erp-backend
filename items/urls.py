from rest_framework import routers

from items.views import ItemMasterViewSet, ItemCategoryViewSet, ServiceViewSet
from orders.views import OrderViewSet

router = routers.DefaultRouter()
router.register(r'items', ItemMasterViewSet)
router.register(r'categories', ItemCategoryViewSet)
# router.register(r'unit-of-measurements', UnitOfMeasurementViewSet)
router.register(r'services', ServiceViewSet)
# router.register(r'process-masters', ProcessMasterViewSet)

urlpatterns = [

]

urlpatterns += router.urls
