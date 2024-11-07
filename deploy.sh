#!/bin/bash

env_name=${1:-sandbox}
customer_name=${2:-um-piotrkow}

echo "Deploying for ${env_name} @ ${customer_name}"

stack_prefix="${customer_name}-${env_name}"

# shared stacks
aws cloudformation deploy \
    --stack-name "${env_name}-devops" \
    --template-file "cloudformation/devops.yaml" \
    --tags stage:name=${env_name} \
    --parameter-overrides WrzasqPlCformVersion=1.4.0 \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM

# per-customer stacks (in case of multi-customer deployment)
aws cloudformation deploy \
    --stack-name "${stack_prefix}-storage" \
    --template-file "cloudformation/storage.yaml" \
    --tags stage:name=${env_name} \
    --parameter-overrides "CustomerName=${customer_name}"
aws cloudformation deploy \
    --stack-name "${stack_prefix}-open-search" \
    --template-file "cloudformation/open-search.yaml" \
    --tags stage:name=${env_name} \
    --parameter-overrides "CustomerName=${customer_name}"
aws cloudformation deploy \
    --stack-name "${stack_prefix}-knowledge-base" \
    --template-file "cloudformation/knowledge-base.yaml" \
    --tags stage:name=${env_name} \
    --parameter-overrides "CustomerName=${customer_name}" \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM
