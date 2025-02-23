#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" 

echo -e "${BLUE}Updating & installing Git...${NC}"
sudo apt update && sudo apt install -y git

TARGET_DIR="/usr/local/bin/Wireguard-panel"
REPO_URL="https://github.com/69learn/Wireguard-panel.git"

if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Setup dir $TARGET_DIR already exists. Removing it for a fresh copy.${NC}"
    sudo rm -rf "$TARGET_DIR"
fi

echo -e "${BLUE}Cloning Wireguard-panel repo into $TARGET_DIR...${NC}"
sudo git clone "$REPO_URL" "$TARGET_DIR"

SETUP_SCRIPT="$TARGET_DIR/src/setup.sh"
if [ -f "$SETUP_SCRIPT" ]; then
    echo -e "${GREEN}Making setup.sh executable...${NC}"
    sudo chmod +x "$SETUP_SCRIPT"

    echo -e "${GREEN}Running setup.sh...${NC}"
    cd "$TARGET_DIR/src" || exit 1
    sudo ./setup.sh
else
    echo -e "${RED}setup.sh not found in $TARGET_DIR/src.${NC}"
    exit 1
fi

echo -e "${GREEN}Setup complete.${NC}"

WIRE_SCRIPT="/usr/local/bin/wire"

if [ ! -f "$WIRE_SCRIPT" ]; then
    echo -e "${GREEN}Creating 'wire' to run from anywhere..${NC}"

    echo -e "#!/bin/bash" | sudo tee "$WIRE_SCRIPT" > /dev/null
    echo -e "cd $TARGET_DIR/src && sudo ./setup.sh" | sudo tee -a "$WIRE_SCRIPT" > /dev/null

    sudo chmod +x "$WIRE_SCRIPT"
else
    echo -e "${YELLOW}'wire' command already exists. Skipping creation.${NC}"
fi

echo -e "${GREEN}run the script from anywhere by typing 'wire'.${NC}"
