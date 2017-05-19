#!/bin/bash

# setup script for hitagi-script

echo "~~ Setup Script ~~"

echo "Installing node"
DISTRO=$(lsb_release -si)
if [ "$DISTRO" == "Debian" ]; then # non debian users can install it themselves got damit
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Please install nodejs 7.x for your distro. See: https://nodejs.org/en/download/package-manager/ for help"
fi

echo "Name of target art?" # folder name
read name
echo "Name in kanji?" # pixiv name
read kanji
echo "name as it appears in danbooru search (with underscores)" # danbooru name
read danbooru

# replace content text in the script
sed -i -e "s/hitagi/$name/g" run.sh
sed -i -e "s/hitagi/$name/g" clean_danbooru.sh
sed -i -e "s/senjougahara_hitagi/$danbooru/g" danbooru-download.js
sed -i -e "s/tobereplaced/$kanji/g" pixiv-download.js
