from rest_framework import routers

from coupons.views import CouponViewSet

router = routers.DefaultRouter()
router.register(r'coupons', CouponViewSet)

urlpatterns = [

]

urlpatterns += router.urls
