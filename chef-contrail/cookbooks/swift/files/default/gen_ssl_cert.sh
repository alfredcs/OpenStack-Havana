#!/bin/bash
openssl req -new -x509 -nodes -out /etc/swift/api-cert.pem -keyout /etc/swift/api-key.pem
