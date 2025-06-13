#!/bin/bash

# HashiCorp Vault Enterprise GitLab JWT Demo
# This script automates the setup process described in the README

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables
VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-root}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Vault Enterprise GitLab JWT Setup  ${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check if Vault CLI is installed
if ! command -v vault &> /dev/null; then
    echo -e "${RED}❌ Vault CLI is not installed. Please install it first.${NC}"
    echo -e "${BLUE}   Download from: https://developer.hashicorp.com/vault/docs/install${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running. Please start Docker Desktop.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are satisfied.${NC}"
echo

# Check Vault connectivity
echo -e "${YELLOW}Verifying Vault connectivity...${NC}"
export VAULT_ADDR VAULT_TOKEN

if ! vault status &> /dev/null; then
    echo -e "${RED}❌ Cannot connect to Vault at $VAULT_ADDR${NC}"
    echo -e "${BLUE}   Please ensure Vault is running: ./vault.sh${NC}"
    exit 1
fi

# Check if this is Vault Enterprise
if ! vault read sys/license/status &> /dev/null; then
    echo -e "${RED}❌ Vault Enterprise license not detected.${NC}"
    echo -e "${BLUE}   Please ensure you have a valid vault.hclic file and restart Vault.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Vault Enterprise is running and accessible.${NC}"
echo

