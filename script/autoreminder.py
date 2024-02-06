import boto3
import datetime
import os

def lambda_handler(event, context):
    iam_client = boto3.client('iam')
    ses_client = boto3.client('ses')

    SENDER_EMAIL = os.environ['SENDER_EMAIL']

    today = datetime.datetime.utcnow()
    ninety_days_ago = today - datetime.timedelta(days=90)

    # Retrieve all IAM users
    try:
        users = iam_client.list_users()['Users']
    except Exception as e:
        print(f"Error retrieving users: {e}")
        return

    # Check for keys older than 90 days for each user
    for user in users:
        user_name = user['UserName']

        # Retrieve user's tags (replace with your specific tag key if different)
        try:
            tags = iam_client.list_user_tags(UserName=user_name)['Tags']
        except Exception as e:
            print(f"Error retrieving tags for user {user_name}: {e}")
            continue

        # Find "Email" tag and extract value
        recipient_email = None
        for tag in tags:
            if tag['Key'] == 'Email':
                recipient_email = tag['Value']
                break

        if not recipient_email:
            print(f"User {user_name} doesn't have an 'Email' tag.")
            continue

        # Retrieve user's access keys
        try:
            access_keys = iam_client.list_access_keys(UserName=user_name)['AccessKeyMetadata']
        except Exception as e:
            print(f"Error retrieving access keys for user {user_name}: {e}")
            continue

        # Check for keys older than 90 days
        for key in access_keys:
            created_date = key['CreateDate'].replace(tzinfo=None)  # Remove timezone info for comparison
            if created_date < ninety_days_ago:
                try:
                    # Send email reminder
                    response = ses_client.send_email(
                        Destination={
                            'ToAddresses': [
                                recipient_email,
                            ],
                        },
                        Message={
                            'Body': {
                                'Text': {
                                    'Charset': 'UTF-8',
                                    'Data': f"Reminder: Please rotate your AWS access key for user {user_name}. It was created on {created_date.strftime('%Y-%m-%d')} and is approaching the 90-day expiration period.",
                                },
                            },
                            'Subject': {
                                'Charset': 'UTF-8',
                                'Data': 'AWS Access Key Rotation Reminder',
                            },
                        },
                        Source=SENDER_EMAIL,
                    )
                    print(f"Email sent to {recipient_email} with message ID: {response['MessageId']}")
                except Exception as e:
                    print(f"Error sending email to {recipient_email}: {e}")