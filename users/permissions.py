from rest_framework.permissions import BasePermission


class GroupWisePermission(BasePermission):
    def has_permission(self, request, view):
        print(request.user.has_perm('events.add_event'))
        return request.user.has_perm('events.add_event')
        # return True

    def has_model_permissions(self, model, perms, app):
        print(self, model, perms, app)

        for p in perms:

            if not self.has_perm("%s.%s_%s" % (app, p, model.__name__)):
                return False

            return True
