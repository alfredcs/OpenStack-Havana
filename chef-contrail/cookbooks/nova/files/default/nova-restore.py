#!/usr/bin/python
import novaclient.v1_1.client as nvclient
import os
import sys

def get_nova_creds():
    d = {}
    d['project_id'] = os.environ['OS_TENANT_NAME']
    d['username'] = os.environ['OS_USERNAME']
    d['api_key'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    return d

if __name__ == '__main__':
    dump_file = '/var/lib/nova/running-instances'
    if not os.path.exists(dump_file):
        sys.exit(0)
    lines = [ line.strip() for line in open(dump_file,'r') ]
    if len(lines) is 0:
        sys.exit(0)

    creds = get_nova_creds()
    nova = nvclient.Client(**creds)
    for line in lines:
        nova.servers.reboot(line)
    sys.exit(0)

