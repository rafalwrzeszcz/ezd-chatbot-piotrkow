#!/bin/bash

env_name=${1:-sandbox}
customer_name=${2:-um-piotrkow}

echo "Deploying for ${env_name} @ ${customer_name}"

stack_prefix="${customer_name}-${env_name}"

aws cloudformation deploy \
    --stack-name "${stack_prefix}-storage" \
    --template-file "cloudformation/storage.yaml" \
    --tags stage:name=${env_name}
