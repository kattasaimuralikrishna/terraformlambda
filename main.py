import boto3
import json
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodbTableName = 'products'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(dynamodbTableName)

getMethod = 'GET'
postMethod = 'POST'
patchMethod = 'PATCH'
deleteMethod = 'DELETE'
healthPath = '/health'
productPath = '/product'
productsPath = '/products'





def lambda_handler(event, context):
    logger.info(event)
    httpMethod = event['httpMethod']
    path = event['path']
    if httpMethod == getMethod and path == healthPath:
       response = buildResponse(200)
    elif httpMethod == getMethod and path == productPath:
        response = getProduct(event['queryStringParameters']['productId'])
    elif httpMethod == getMethod and path == productsPath:
        response = getProducts()
    elif httpMethod == postMethod and path == productPath:
        response = saveProducts(json.loads(event['body']))
    elif httpMethod == deleteMethod and path == productPath:
        requestBody = json.loads(event['body'])
        response = deleteProduct(requestBody['productId'])
    else:
        response = buildResponse(400, 'Not Found')
    return response

def getProduct(productId):
    try:
        response= table.get_item(
            Key={
                'productId' : productId
            }
        )
        if 'Item' in response :
            return buildResponse(200, response['Item'])
        else:
            return buildResponse(404, {'Message': 'ProductId: %s not found' % productId})
    except:
        logger.exception('Do your error handling here')

def getProducts():
    try:
        response = table.scan()
        result = response['Items']

        while 'LastEvaluatedkey' in response:
            response = table.scan(ExclusiveStartkey=response['LastEvaluatedkey'])
            result.extend(response['Items'])
        body = {
            'products' : result
        }
        return buildResponse(200, body)
    except:
        logger.exception('do you custm error')

def saveProducts(requestBody):
    try:
        table.put_item(Item=requestBody)
        body = {
            'Operation' : 'SAVE',
            'Message' : 'SUCCESS',
            'Item' : requestBody
        }
        return buildResponse(200,body)
    except:
        logger.exception('do your custom error')
        
def deleteProduct(productId):
    try:
        response = table.delete_item(
            Key={
                'productId': productId
            },
            ReturnValues='ALL_OLD'
        )
        body = {
            'Operation': 'DELETE',
            'Message': 'SUCCESS',
            'deleteItem': response
        }
        return buildResponse(200, body)
    except:
        logger.exception('do your custom error')


def buildResponse(statusCode, body=None):
    response = {
        'statusCode' : statusCode,
        'headers':{
            'content-Type' : 'application/json',
            'Access-Control-Allow-Origin' : '*'
        }
    }
    if body is not None:
        response['body'] = json.dumps(body)
    return response