#!/bin/bash

# Ensure the script is run as sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31m❌ This script must be run as root\e[0m"
   exit 1
fi

# Define variables
INTERFACE="eth0"
DEFAULT_GATEWAY="100.115.92.193"
PING_TARGET="8.8.8.8"

# Define colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m' # No Color

# Function to check if the network interface is up
check_interface() {
    ip link show $INTERFACE | grep "state UP" > /dev/null
    return $?
}

# Function to bring up the network interface
bring_up_interface() {
    ip link set $INTERFACE up
}

# Function to check if the default gateway is set
check_gateway() {
    ip route | grep "default via $DEFAULT_GATEWAY" > /dev/null
    return $?
}

# Function to add the default gateway
add_gateway() {
    ip route add default via $DEFAULT_GATEWAY
}

# Function to ping and check connectivity
check_connectivity() {
    ping -c 4 $PING_TARGET > /dev/null
    return $?
}

# Main script logic
echo -e "${BLUE}🔍 Checking network interface status...${NC}"
if ! check_interface; then
    echo -e "${RED}❌ Network interface $INTERFACE is down. Bringing it up...${NC}"
    bring_up_interface
    sleep 2 # Wait a moment for the interface to come up
else
    echo -e "${GREEN}✅ Network interface $INTERFACE is up.${NC}"
fi

echo -e "${BLUE}🔍 Checking default gateway...${NC}"
if ! check_gateway; then
    echo -e "${RED}❌ Default gateway is not set. Adding default gateway $DEFAULT_GATEWAY...${NC}"
    add_gateway
else
    echo -e "${GREEN}✅ Default gateway is already set.${NC}"
fi

echo -e "${BLUE}🔍 Checking network connectivity...${NC}"
if check_connectivity; then
    echo -e "${GREEN}✅ Network connectivity is fine.${NC}"
else
    echo -e "${RED}❌ Network is still unreachable. There might be a deeper issue.${NC}"
fi

# Run speedtest-cli, after confirmation
echo -e "${YELLOW}⚠️  Do you want check the connection speed? (Y/n)${NC}"
stty -echo
read -r -n 1 response
stty echo
echo

# Convert response to lowercase
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

if [[ "$response" == "n" || "$response" == "no" ]]; then
    echo -e "${YELLOW}🚫 Aborting speedtest-cli.${NC}"
    exit 0
fi

echo -e "${BLUE}📶 Running speedtest-cli...${NC}"
speedtest-cli
