#!/bin/bash
# tf.sh - Fully automatic Terraform wrapper
# Usage:
#   TF_ENV=dev ./tf.sh plan
#   TF_ENV=prod ./tf.sh apply
# Default environment is dev if TF_ENV is not set

set -e

# -------------------------------
# 1. Detect environment
# -------------------------------
ENV="${TF_ENV:-dev}"       # Default to dev if TF_ENV not set
CMD="$1"                   # plan/apply/destroy/validate/etc.

if [[ -z "$CMD" ]]; then
  echo "Usage: TF_ENV=<dev|prod> ./tf.sh <command>"
  exit 1
fi

BACKEND_CONF="envs/$ENV/backend.conf"
VAR_FILE="envs/$ENV/terraform.tfvars"

echo "========================================="
echo "Running Terraform [$CMD] for environment: $ENV"
echo "Backend config: $BACKEND_CONF"
echo "Variable file: $VAR_FILE"
echo "========================================="

# -------------------------------
# 2. Initialize backend
# -------------------------------
terraform init -backend-config="$BACKEND_CONF" -reconfigure

# -------------------------------
# 3. Run Terraform command
# -------------------------------
shift 1  # remove the first argument (the command) so $@ contains extra flags
terraform "$CMD" -var-file="$VAR_FILE" "$@"

# -------------------------------
# 4. Success message
# -------------------------------
echo "========================================="
echo "Terraform [$CMD] for [$ENV] completed successfully!"
echo "========================================="
