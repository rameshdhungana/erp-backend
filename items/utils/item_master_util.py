from django.core.exceptions import ObjectDoesNotExist
from items.models import ItemMaster, ItemProcessMaster, GENERAL_PROCESS_MASTER


def get_item_master_object(item_master_uuid):
    try:
        item_master = ItemMaster.objects.get(uuid=item_master_uuid)
        return item_master
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_item_master_object_by_id(item_master_id):
    try:
        item_master = ItemMaster.objects.get(id=item_master_id)
        return item_master
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_item_master_object_by_name(item_master_name):
    try:
        item_master = ItemMaster.objects.get(name=item_master_name)
        return item_master
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_general_item_process_master():
    process_master, created = ItemProcessMaster.objects.get_or_create(name=GENERAL_PROCESS_MASTER)
    return process_master


# this function returns the item_master object created on initial data migration
# based on what name is passed to it
def get_item_master_object_by(item_master_name):
    try:
        item_master = ItemMaster.objects.get(name=item_master_name)
        return item_master
    except ObjectDoesNotExist as e:
        raise Exception(e)
