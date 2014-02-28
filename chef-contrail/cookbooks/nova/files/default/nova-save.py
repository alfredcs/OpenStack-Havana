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
    creds = get_nova_creds()
    nova = nvclient.Client(**creds)
    servers = nova.servers.list()
    filtered = [ server.id for server in servers if server.status == 'ACTIVE' ]
    fp = open(dump_file,'w')
    fp.write('\n'.join(filtered))
    sys.exit(0)

