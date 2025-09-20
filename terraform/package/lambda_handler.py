import json
import boto3
import datetime
import yaml

from botocore.exceptions import ClientError
now = datetime.datetime.now()

def download_tenant_yaml():
    s3 = boto3.client('s3')
    s3.download_file("vindot-llc-tenants", "tenants.yml", "/tmp/tenants.yml")

def verify_tenant(email, unit):
    status = False
    with open('/tmp/tenants.yml', 'r') as file:
        data = yaml.safe_load(file)
    
    for tenant in data['tenants']:
        if (tenant['email'] == email and 
            tenant['unit'] == unit):
            status = True
    return status


def lambda_handler(event, context):
    # Log the entire event object for debugging
    print("Event:", json.dumps(event))
    
    # Extract query parameters
    query_params = event.get('queryStringParameters', {})
    
    email = query_params.get('email')
    unit = query_params.get('unit')
    text =  query_params.get('text')

    download_tenant_yaml()
    result = (verify_tenant(email,unit))
    if result == True:
        print("Forward to LLC")
    else:
        return {
            'statusCode': 401, #403
            'headers': {
                'Location': 'https://5069-pernod-form.s3.us-east-2.amazonaws.com/not-current-tenant.html', # point to redirects
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            }
        }
    
    message = (f"VINDOT FTW")
        # This address must be verified with Amazon SES.
    SENDER = "owners@vindot.llc"
    RECIPIENTS = ["dprme1@yahoo.com"]
    SUBJECT = " VINDOT LLC Form Response"
    BODY_TEXT = message
    
    BODY_HTML = """
    Email: {}
    <br>
    Unit: {}
    <br>
    Message: {}
    <br>
    """.format(email, unit, text)

    print(BODY_HTML)

    CHARSET = "UTF-8"
    client = boto3.client('ses', region_name="us-east-2")
    try:
        # Provide the contents of the email.
        response = client.send_email(
            Destination={
                'ToAddresses': RECIPIENTS,
            },
            Message={
                'Body': {
                    'Html': {
                        'Charset': CHARSET,
                        'Data': BODY_HTML,
                    },
                    'Text': {
                        'Charset': CHARSET,
                        'Data': BODY_TEXT,
                    },
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': SUBJECT,
                },
            },
            Source=SENDER,
            # If you are not using a configuration set, comment or delete the
            # following line
            # ConfigurationSetName=CONFIGURATION_SET,
        )
    # Display an error if something goes wrong.	
    except ClientError as e:
        return {
            'statusCode': 500,
            'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps(e.response['Error']['Message'])
        }
    else:
        return {
            'statusCode': 200,        
            'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps("Email sent! Message ID: " + response['MessageId'])
        }
    # Return a response
