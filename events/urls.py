from django.urls.conf import path
from rest_framework import routers
from rest_framework_nested import routers as nested_routers

from events.views import (EventAttendeeViewSet, ConfigurationViewSet,
                          EventCategoryViewSet, EventItemGroupViewSet,
                          EventItemViewSet, EventRegistrationTypeViewSet,
                          EventTypeViewSet, EventViewSet, OrganizerViewSet, AttendeeViewSet,
                          EventCancellationPolicyViewSet, CreditorListView, DebitorListView,
                          AttendeeAccommodationWiseFilterView, RefundListView, ReceiptListView)
from events.views.accommodation_room_view import AccommodationRoomViewSet
from events.views.transportation_pickup_location_view import TransportationPickupLocationViewSet

router = routers.DefaultRouter()
router.register(r'events', EventViewSet, base_name='events')
router.register(r'types', EventTypeViewSet, base_name='event_type')
router.register(r'categories', EventCategoryViewSet, base_name='event_category')
router.register(r'organizers', OrganizerViewSet, base_name='organizer')
router.register(r'configurations', ConfigurationViewSet, base_name='configurations')
router.register(r'attendees', AttendeeViewSet, base_name='attendees')

# for nested router part
nested_router = nested_routers.SimpleRouter()
nested_router.register(r'', EventViewSet, base_name='events')
events_router = nested_routers.NestedSimpleRouter(nested_router, r'', lookup='event')
events_router.register(r'event-items', EventItemViewSet, base_name='event-items')
events_router.register(r'item-groups', EventItemGroupViewSet, base_name='event-item-groups')
events_router.register(r'registration-types', EventRegistrationTypeViewSet, base_name='event_registration_type')
events_router.register(r'attendees', EventAttendeeViewSet, base_name='attendees')
events_router.register(r'accommodation-rooms', AccommodationRoomViewSet, base_name='accommodation-rooms')
events_router.register(r'transportation-pickup-locations', TransportationPickupLocationViewSet,
                       base_name='transportation-pickup-locations')
events_router.register(r'cancellation-policy', EventCancellationPolicyViewSet, base_name='event_cancellation_policy')
# events_router.register(r'orders', ItemCartViewSet, base_name='carts')

# 'base_name' is optional. Needed only if the same viewset is registered more than once
# Official DRF docs on this option: http://www.django-rest-framework.org/api-guide/routers/


urlpatterns = [
    path('<slug:event_uuid>/creditor-list/', CreditorListView.as_view()),
    path('<slug:event_uuid>/debitor-list/', DebitorListView.as_view()),
    path('<slug:event_uuid>/accommodation-wise-attendee-list/', AttendeeAccommodationWiseFilterView.as_view()),
    path('<slug:event_uuid>/refund-list/', RefundListView.as_view()),
    path('<slug:event_uuid>/receipt-list/', ReceiptListView.as_view())
]

urlpatterns += router.urls
urlpatterns += nested_router.urls
urlpatterns += events_router.urls
