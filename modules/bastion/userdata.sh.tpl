#!/bin/bash
set -e
# Update & install SSM agent if needed
sudo apt-get update -y
sudo apt-get install -y snapd
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service
