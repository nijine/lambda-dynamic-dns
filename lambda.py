import boto3
import os


session = boto3.session.Session()
r53_cli = session.client('route53')

HOSTED_ZONE_ID = os.environ['HOSTED_ZONE_ID']
SERVER_PREFIX = os.environ['SERVER_PREFIX']
DOMAIN_NAME = os.environ['DOMAIN_NAME']


def lambda_handler(event, context):
    latest_ip = event['ip']

    response = r53_cli.change_resource_record_sets(
        HostedZoneId=HOSTED_ZONE_ID,
        ChangeBatch={
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': f"{SERVER_PREFIX}.{DOMAIN_NAME}",
                        'Type': 'A',
                        'ResourceRecords': [
                            {
                                'Value': latest_ip
                            },
                        ],
                        'TTL': 60,
                    },
                },
            ],
        }
    )

    # Should return 'PENDING'
    return response.get('ChangeInfo', {}).get('Status', 'EMPTY')

