#!/bin/bash

osName=$(uname -s)
DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/datreeio/datree/releases/latest" | grep -o "browser_download_url.*\_${osName}_x86_64.zip")

DOWNLOAD_URL=${DOWNLOAD_URL//\"}
DOWNLOAD_URL=${DOWNLOAD_URL/browser_download_url: /}

OUTPUT_BASENAME=datree-latest
OUTPUT_BASENAME_WITH_POSTFIX=$OUTPUT_BASENAME.zip

echo "Installing Datree..."
echo

curl -sL $DOWNLOAD_URL -o $OUTPUT_BASENAME_WITH_POSTFIX
echo -e "\033[32m[V] Downloaded Datree"

if ! unzip >/dev/null 2>&1;then
    echo -e "\033[31;1m error: unzip command not found \033[0m"
    echo -e "\033[33;1m install unzip command in your system \033[0m"
    exit 1
fi

unzip -qq $OUTPUT_BASENAME_WITH_POSTFIX -d $OUTPUT_BASENAME

mkdir -p ~/.datree

rm -f /usr/local/bin/datree || sudo rm -f /usr/local/bin/datree
cp $OUTPUT_BASENAME/datree /usr/local/bin || sudo cp $OUTPUT_BASENAME/datree /usr/local/bin

rm $OUTPUT_BASENAME_WITH_POSTFIX
rm -rf $OUTPUT_BASENAME

curl -s https://get.datree.io/k8s-demo.yaml > ~/.datree/k8s-demo.yaml
echo -e "[V] Finished Installation"

echo

echo -e "\033[35m Usage: $ datree test ~/.datree/k8s-demo.yaml"

echo -e " Using Helm? => https://hub.datree.io/helm-plugin \033[0m"

tput init

echo
