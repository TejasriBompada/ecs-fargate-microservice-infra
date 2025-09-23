#!/bin/bash
# tf.sh - Fully automatic Terraform wrapper
# Usage:
#   TF_ENV=dev ./tf.sh plan -out=tfplan
#   TF_ENV=prod ./tf.sh apply -auto-approve
# Default environment is dev if TF_ENV is not set

set -e

# -------------------------------
# 1. Detect environment
# -------------------------------
ENV="${TF_ENV:-dev}"       # Default to dev if TF_ENV not set
CMD="$1"                   # plan/apply/destroy/validate/etc.

if [[ -z "$CMD" ]]; then
  echo "Usage: TF_ENV=<dev|prod> ./tf.sh <command> [extra-args]"
  exit 1
fi

# All extra args after the command
shift 1
EXTRA_ARGS="$@"

BACKEND_CONF="envs/$ENV/backend.conf"
VAR_FILE="envs/$ENV/terraform.tfvars"

echo "========================================="
echo "Running Terraform [$CMD] for environment: $ENV"
echo "Backend config: $BACKEND_CONF"
echo "Variable file: $VAR_FILE"
echo "Extra args: $EXTRA_ARGS"
echo "========================================="

# -------------------------------
# 2. Initialize backend
# -------------------------------
terraform init -backend-config="$BACKEND_CONF" -reconfigure

# -------------------------------
# 3. Run Terraform command
# -------------------------------
terraform "$CMD" -var-file="$VAR_FILE" $EXTRA_ARGS

# -------------------------------
# 4. Success message
# -------------------------------
echo "========================================="
echo "Terraform [$CMD] for [$ENV] completed successfully!"
echo "========================================="
