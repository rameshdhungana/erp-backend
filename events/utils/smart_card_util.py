def validate_smart_card_number(smart_card_number):
    # card = EventAttendee.objects.filter(smart_card_number=smart_card_number).first()
    # if card:
    #     #  since card already exists , data is not valid for further processing
    #     self.invalid_user_data_collection.append(
    #         {'message': 'It seems like smart card number `{}` is already associated to another account '.format(
    #             smart_card_number),
    #             'status': 'ALREADY'})
    #     return False
    # else:
    #     #  card already does not exits, data is valid for further processing
    return True
