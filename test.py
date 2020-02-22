# import shutil
#
# import requests
# from phonenumber_field.serializerfields import PhoneNumberField
#
# data = [11111111111, 22222222222222222, 33333333333333, 4444444444444]
#
# url = 'https://www.barcodesinc.com/generator_files/' + 'image.php?'
#
# for d in data:
#     params = {
#
#         'code': d,
#         'style': '197',
#         'type': 'C128B',
#         'width': '200',
#         'height': '50',
#         'xres': '1',
#         'font': '3',
#     }
#     response = requests.get(url, params, stream=True)
#     with open('image-%s.png' % d, 'wb') as out_file:
#         shutil.copyfileobj(response.raw, out_file)
#     del response
#
# p = {'countryCode': "NP", 'internationalNumber': "+977 984-5653912", 'nationalNumber': "984-5653912",
#      'number': "9845653912"}
#
#
#


# from pxpaypy.pxpay import PxPay
# from pxpaypy.pxpost import TXN_PURCHASE
#
# pxpay = PxPay("https://<pxpay url>", "1", "yr938y583hfkesjhf")
# print(pxpay.__dict__)
# response = pxpay.make_transaction_request(
#     merchant_reference="sdklfjsdkljf",
#     transaction_type=TXN_PURCHASE,
#     amount=1.00,
#     currency="NZD",
#     transaction_id="lsjdflk",
#     url_success="suces",
#     url_fail="fjksd", mock=True)
# print(response)
# # url = response["url"]
#

# a = [{'a': 1}, {'b': 2}]
# print(a)
# for key,value in enumerate(a):
#     print(a[key])
#     print(len(a))
#     print()
#
#

import datetime
import decimal
import urllib.request, urllib.parse, urllib.error

import securepay
from securepay.securepay import _pay_by_cc_xml, UTCTimezone, logger, GatewayError, _parse_response

MERCHANT_ID = 'ABC0001'
PASSWORD = 'abc123'

#
# # Take a $2 AUD credit card payment.
# try:
#     # pay_response = securepay.pay_by_cc(
#     #     200, 'PO-1234', '4444333322221111', '11/28',
#     #     securepay.TEST_API_URL, MERCHANT_ID, PASSWORD, 'Card Holder Name')
#     # print(pay_response)
#     [cents, purchase_order_id, cc_number, cc_expiry,
#      api_url, merchant_id, password, cc_holder, recurring] = [decimal.Decimal(10508), 'PO-1234', '4444333322221111',
#                                                               '11/18',
#                                                               securepay.TEST_API_URL, MERCHANT_ID, PASSWORD,
#                                                               'Card Holder Name', False]
#     timestamp = datetime.datetime.now(UTCTimezone())
#     xml = _pay_by_cc_xml(timestamp, cents, purchase_order_id, cc_number, cc_expiry, merchant_id,
#                          password, cc_holder, recurring)
#     logger.debug(xml)
#     try:
#         response_xml = urllib.request.urlopen(securepay.TEST_API_URL, xml).read()
#     except urllib.error.URLError as err:
#         raise GatewayError(err)
#     response = _parse_response(response_xml)
#     print('xml response form the secure pay', response_xml)
#
#     logger.debug(response)
#     print('dict resposne', response)
#
# except securepay.GatewayError as err:
#     print('gateway error:', err)
#     # Service unavailable. Log err and give customers a generic error.
# except securepay.PaymentError as err:
#     # Payment declined. Error message is in err.
#     print('payment  error:', err)
# else:
#     print('payment is successful')

# Payment successful! Details in pay_response.

# Refund the payment above in full.
# try:
#     refund_response = securepay.refund(
#         200, 'PO-1234', '498387',
#         securepay.TEST_API_URL, MERCHANT_ID, PASSWORD)
# except securepay.GatewayError as err:
#     # Service unavailable. Log err and give customers a generic error.
#     print('gateway error:', err)
#
# except securepay.PaymentError as err:
#     # Refund declined. Error message is in err.
#     print('payment  error:', err)
#
# else:
#     # Refund successful! Details in refund_response.
#     print('refund successful')

# EPS_MERCHANTID
# Transaction Password(supplied by SecurePay Support)
# EPS_TXNTYPE
# EPS_REFERENCEID
# EPS_AMOUNT
# EPS_TIMESTAMP

import hashlib
import base64
import hmac

# merchant_id = "ABC0001"
# transaction_password = "abc123"
# transaction_type = "0"
# reference_id = "test"
# amount = "40"
# timestamp = "20190613084410"

merchant_id = "ABC0010"
transaction_password = "abc123"
transaction_type = "0"
reference_id = "Test Reference"
amount = "1.00"
timestamp = "20170307024842"


def get_ssh256_hash_key():
    # return hashlib.sha256(
    #     '{}{}{}{}{}{}'.format(merchant_id, transaction_password, transaction_type, reference_id, amount,
    #                           timestamp).encode()).hexdigest()
    # final_string = '{}|{}|{}|{}|{}|{}'.format(merchant_id, transaction_password, transaction_type, reference_id, amount,
    #                                           timestamp)
    # final_string = bytes(final_string, encoding='utf8')
    # key = bytes('finger_print', encoding='utf8')
    #
    # signature = base64.b64encode(hmac.new(key, final_string, digestmod=hashlib.sha256).digest())
    joined_key = '|'.join([merchant_id, transaction_password, transaction_type, reference_id, amount,
                           timestamp])
    print('joined key=', joined_key)
    # secret_key = bytes(joined_key.strip(), encoding='utf-8')

    # signature = hmac.new(secret_key, hashlib.sha256).hexdigest()
    # print("signature = {0}".format(signature))
    # new_signature = base64.b64encode(hmac.new(secret_key, digestmod=hashlib.sha256).digest())
    # print('new signature', new_signature)

    signature = hashlib.sha256(joined_key.strip().encode()).hexdigest().strip()
    last_joined = '|'.join([joined_key, signature])
    return hashlib.sha256(last_joined.strip().encode()).hexdigest().strip()


print('finger_pirnt=',get_ssh256_hash_key(),'finger print ends')

post_data = {
    'EPS_MERCHANT': merchant_id,
    'EPS_TXNTYPE': transaction_type,
    'EPS_REFERENCEID': reference_id,
    'EPS_AMOUNT': amount,
    'EPS_TIMESTAMP': timestamp,
    'EPS_FINGERPRINT': get_ssh256_hash_key(),
    'EPS_RESULTURL': 'http://events.nipunaprabidhiksewa.net/',
    'EPS_CARDNUMBER': '4444333322221111',
    'EPS_EXPIRYMONTH': '12',
    'EPS_EXPIRYYEAR': '2020',
    'EPS_CCV': '123',
}
# dae18a7c6b223472c7a7c8116acbdbf1170a033c89f3b9b8f940069c453436de
import requests

r = requests.post('https://test.api.securepay.com.au/live/directpost/authorise', post_data)
print(r.__dict__)
""" 



<?xml version="1.0"encoding="UTF-8"?>
<SecurePayMessage>    
    <MessageInfo>
        <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
        <messageTimestamp>20042303111214383000+660</messageTimestamp>         
        <timeoutValue>60</timeoutValue>         
        <apiVersion>xml-4.2</apiVersion>     
    </MessageInfo>     
    <MerchantInfo>         
        <merchantID>ABC0001</merchantID>         
        <password>abc123</password>     
    </MerchantInfo>     
    <RequestType>Payment</RequestType>     
    <Payment>         
        <TxnList count="1">            
            <Txn ID="1">                
                <txnType>0</txnType>                 
                <txnSource>23</txnSource>         
                <amount>200</amount> 
                <recurring>no</recurring>
                <currency>AUD</currency>                
                <purchaseOrderNo>test</purchaseOrderNo>                  
                <CreditCardInfo>                     
                    <cardNumber>4444333322221111</cardNumber>                     
                    <expiryDate>09/23</expiryDate>
                    <cvv>000</cvv>
                </CreditCardInfo>                
            </Txn>         
        </TxnList>     
    </Payment> 
</SecurePayMessage>

"""

"""
<?xml version="1.0"encoding="UTF-8"?>
    <SecurePayMessage>
        <MessageInfo>
            <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
            <messageTimestamp>20042303111226938000+660</messageTimestamp>
            <apiVersion>xml-4.2</apiVersion>
        </MessageInfo>
        <MerchantInfo>
            <merchantID>ABC0001</merchantID>
        </MerchantInfo>
        <RequestType>Payment</RequestType>
        <Status>
            <statusCode>000</statusCode>
            <statusDescription>Normal</statusDescription>
        </Status>
        <Payment>   
            <TxnList count="1">
                <Txn ID="1">
                    <txnType>0</txnType>
                    <txnSource>23</txnSource>
                    <amount>200</amount>
                    <currency>AUD</currency> 
                    <purchaseOrderNo>test</purchaseOrderNo>
                    <approved>Yes</approved>
                    <responseCode>00</responseCode>
                    <responseText>Approved</responseText>
                    <settlementDate>20040323</settlementDate>
                    <txnID>009887</txnID>
                    <CreditCardInfo>
                        <pan>444433...111</pan>
                        <expiryDate>09/23</expiryDate>
                        <cardType>6</cardType>
                        <cardDescription>Visa</cardDescription>
                    </CreditCardInfo>
                </Txn>
            </TxnList>
        </Payment>
</SecurePayMessage>
"""
