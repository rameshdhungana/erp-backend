from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from items.models import ItemCategory, DEFAULT_ITEM_MASTER_CATEGORIES
from items.serializers import ItemCategorySerializer


class ItemCategoryViewSet(ModelViewSet):
    serializer_class = ItemCategorySerializer
    queryset = ItemCategory.objects.all()
    lookup_field = 'uuid'

    def get_queryset(self):
        custom_queryset = self.queryset
        #  default created item categories are to be excluded
        for name in dict(DEFAULT_ITEM_MASTER_CATEGORIES):
            custom_queryset = custom_queryset.exclude(name=name)
        return custom_queryset

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Item Category List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
