from collections import OrderedDict

from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response


class CustomPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = 'page_size'
    max_page_size = 10

    def paginate_queryset(self, queryset, request, view=None):
        if 'no_page' in request.query_params:
            return None

        return super().paginate_queryset(queryset, request, view)

    def get_paginated_response(self, data):
        paginator = self.page.paginator

        return Response(OrderedDict([
            ('pagination', {
                'has_next': self.page.has_next(),
                'has_previous': self.page.has_previous(),
                'count': self.page.paginator.count,
                'pages': paginator.num_pages,
                'page_size': self.get_page_size(self.request)
            }),
            ('results', data)
        ]))
