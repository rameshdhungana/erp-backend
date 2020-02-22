from allauth.account.adapter import DefaultAccountAdapter


# Overwrites email confirmation url so that the correct url is sent in the email.
# to change the actual address, see core.urls name: 'account_confirm_email'
class MyAccountAdapter(DefaultAccountAdapter):
    def get_email_confirmation_url(self, request, emailconfirmation):
        # email = emailconfirmation.email_address.email
        # set_password_link_sent = request.session.get(email, False)
        # print(emailconfirmation.email_address.email)
        # # we check if the session key for given email has been assinged as True for
        # #  sending set password link , if yes  then set password link is sent else , verify email link is
        # # sent
        # print('this is inside the adaptor', request.session.get(email))
        # if set_password_link_sent:
        #     # delete the session for given emailaddress
        #     del request.session[email]
        #
        #     return settings.FRONTEND_SET_PASSWORD_URL + signing.dumps(
        #         {'email': email}) + '/'
        # else:
        #     # this case is for the global users registration (users creating own account instead of
        #     #  business adding them
        #     return settings.FRONTEND_VERIFY_URL + emailconfirmation.key
        pass
