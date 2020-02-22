from django.urls.conf import path
from rest_framework import routers

from payments.views import redeem_balance, pay_balance, topup_balance

router = routers.DefaultRouter()

urlpatterns = [
    path('redeem-balance/', redeem_balance),
    path('pay-balance/', pay_balance),
    path('topup-balance/', topup_balance)
]

urlpatterns += router.urls
