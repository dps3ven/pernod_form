import json
import boto3
import datetime

from botocore.exceptions import ClientError
now = datetime.datetime.now()

def lambda_handler(event, context):
    # Log the entire event object for debugging
    print("Event:", json.dumps(event))
    
    # Extract query parameters
    query_params = event.get('queryStringParameters', {})
    
    name = query_params.get('name')
    email = query_params.get('email')
    phone =  query_params.get('phone')
    text =  query_params.get('text')

    
    # message = "{} {} {}".format(manner, business, family)
    
    # Your logic here
    message = (f"VINDOT FTW")
        # This address must be verified with Amazon SES.
    SENDER = "owners@vindot.llc"
    RECIPIENTS = ["dprme1@yahoo.com"]
    SUBJECT = " VINDOT LLC Form Response"
    BODY_TEXT = message
    
    BODY_HTML = """
    Name: {}
    <br>
    Email: {}
    <br>
    Phone: {}
    <br>
    Message: {}
    <br>
    """.format(name, email, phone, text)

    print(BODY_HTML)
    # # The HTML body of the email.
    # BODY_HTML = """<html>
    # <head></head>
    # <body>
    #   <h1>Hello!</h1>
    #   <p>{message}</p>
    # </body>
    # </html>
   #"""
    

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
