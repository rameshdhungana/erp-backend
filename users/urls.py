from django.urls import path, re_path
from rest_auth.registration.views import VerifyEmailView
from rest_auth.views import LogoutView, UserDetailsView
from rest_framework import routers

from users.views import (AuthPermissionListView, GroupViewSet,
                         StaffRegisterView, UserLoginView, UserRegisterView,
                         UserViewSet)

router = routers.DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'groups', GroupViewSet)

urlpatterns = [
    path('register-user/', UserRegisterView.as_view(), name='user_registration'),
    path('register-staff/', StaffRegisterView.as_view(), name='staff_registration'),
    # login/logout
    path('login/', UserLoginView.as_view(), name='user_login'),
    path('logout/', LogoutView.as_view(), name='user_logout'),
    path('detail/', UserDetailsView.as_view(), name='user_detail'),
    re_path(r'^account-confirm-email/', VerifyEmailView.as_view(),
            name='account_email_verification_sent'),
    re_path(r'^account-confirm-email/(?P<key>[-:\w]+)/$', VerifyEmailView.as_view(),
            name='account_confirm_email'),

    # users permissions list view
    path('permissions/', AuthPermissionListView.as_view())
]

urlpatterns += router.urls
