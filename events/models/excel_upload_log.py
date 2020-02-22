import uuid as uuid

from django.db import models

from users.models import Base

ACCOMMODATION_ROOM_ALLOCATION = 'Accommodation-Room-Allocation'
ACCOMMODATION_ROOM_CREATION = 'Accommodation-Room-Creation'
EXCEL_UPLOAD_LOG_TYPE = (
    (ACCOMMODATION_ROOM_ALLOCATION, ACCOMMODATION_ROOM_ALLOCATION),
    (ACCOMMODATION_ROOM_CREATION, ACCOMMODATION_ROOM_CREATION)
)


class ExcelUploadLog(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    type = models.CharField(max_length=255, choices=EXCEL_UPLOAD_LOG_TYPE)
    total_processing = models.IntegerField()
    total_success = models.IntegerField()
    total_failure = models.IntegerField()

    def __repr__(self):
        return 'Type: {}- Total Processing: {}-Total-Failure: {}-Total success: {}'.format(self.type,
                                                                                           self.total_processing,
                                                                                           self.total_failure,
                                                                                           self.total_success)

    def __str__(self):
        return 'Type: {}- Total Processing: {}-Total-Failure: {}-Total success: {}'.format(self.type,
                                                                                           self.total_processing,
                                                                                           self.total_failure,
                                                                                           self.total_success)
