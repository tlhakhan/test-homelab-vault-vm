#!/bin/bash

INIT_STATUS=$(curl -Ls http://vault:8200/v1/sys/init | jq -r .initialized)
if [[ $INIT_STATUS == "false" ]]
then
  curl -Ls -X PUT -H "X-Vault-Request: true" -d @key_shares.json http://vault:8200/v1/sys/init | jq | tee /vault/keys/vault-initialized.json
else
  cat /vault/keys/vault-initialized.json
fi

# spin
while true
do
  sleep 3600
done
