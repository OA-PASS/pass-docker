#!/bin/bash

# Supplies environment varibles, that when evaluated, allow
# the current user to assume the role identified in ${ROLE_ARN}.

# Example usage: 
#  Echo environment variables without assuming the role:
#   $ assume-aws-role.sh
#  Assume the role:
#   $ eval $(assume-aws-role.sh)

# Requires:
#  aws cli: https://aws.amazon.com/cli/
#  jq: https://stedolan.github.io/jq/


ROLE_ARN=arn:aws:iam::917326998031:role/ECS_Pass_Cluster_Management
ROLE_NAME=pass_mgmt
declare -a ROLE_CREDS

function drop_role()
{
  for e in "AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID" ; do unset $e ; done
}

function obtain_role()
{
  ROLE_CREDS=($(aws sts assume-role --role-arn ${ROLE_ARN} --role-session-name ${ROLE_NAME} | jq -r '[.Credentials.SessionToken, .Credentials.SecretAccessKey, .Credentials.AccessKeyId] | @sh'))
}

drop_role
obtain_role

echo "export AWS_SESSION_TOKEN=${ROLE_CREDS[0]}"
echo "export AWS_SECRET_ACCESS_KEY=${ROLE_CREDS[1]}"
echo "export AWS_ACCESS_KEY_ID=${ROLE_CREDS[2]}"