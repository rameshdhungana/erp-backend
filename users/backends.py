from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend
from django.db.models import Q

UserModel = get_user_model()


# we have customized the authentication backend to authenticate users either by username or phone_number
class UsernameOrPhoneAuthentication(ModelBackend):

    def authenticate(self, request, username=None, password=None, **kwargs):
        print('hello authentication', username)
        try:
            # Try to fetch the users by searching the username or phone_number field or emailwer
            user = UserModel._default_manager.get(Q(username=username) | Q(phone_number=username) | Q(email=username))

        except UserModel.DoesNotExist:
            # Run the default password hasher once to reduce the timing
            # difference between an existing and a nonexistent users (#20760).
            UserModel().set_password(password)
        else:
            if user.check_password(password) and self.user_can_authenticate(user):
                return user
