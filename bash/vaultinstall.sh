#!/bin/bash

vault_ver=1.2.3
vault_addr="set vault address here"
vault_zip=vault_"$vault_ver"_darwin_amd64.zip
me="$USER"

sudo mkdir -p -m 755 /usr/local/bin
cd /usr/local/bin 
curl -L0 https://releases.hashicorp.com/vault/$vault_ver/$vault_zip --output $vault_zip
unzip -o $vault_zip
rm -f $vault_zip
chmod +x /usr/local/bin/vault
if cat ~/.profile | grep -q VAULT_ADDR
then
  echo env variable is already exported
else
  echo env variable was not exported, but now it is
  echo 'export VAULT_ADDR=$vault_addr' >> ~/.profile
fi
source ~/.profile
echo 'logging into vault'
vault login -method=aws role=secret region=us-east-1
echo 'Testing vault get'
vault kv get secret/hello
echo 'Success!'
