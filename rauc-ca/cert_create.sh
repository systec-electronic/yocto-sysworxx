#!/bin/sh

openssl req -x509 -newkey rsa:4096 -keyout rauc.key -out rauc.crt -days 3650 -nodes
openssl x509 -in rauc.crt -text
