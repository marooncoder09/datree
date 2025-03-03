
#!/bin/bash

osName=$(uname -s)
DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/datreeio/datree/releases" | grep -o -m 1 "browser_download_url.*internal_${osName}_x86_64.zip")

DOWNLOAD_URL=${DOWNLOAD_URL//\"}
DOWNLOAD_URL=${DOWNLOAD_URL/browser_download_url: /}


OUTPUT_BASENAME=datree-latest
OUTPUT_BASENAME_WITH_POSTFIX=$OUTPUT_BASENAME.zip

echo "Installing Datree (internal)..."
echo

curl -sL $DOWNLOAD_URL -o $OUTPUT_BASENAME_WITH_POSTFIX
echo -e "\033[32m[V] Downloaded Datree"

if ! unzip >/dev/null 2>&1;then
    echo -e "\033[31;1m error: unzip command not found \033[0m"
    echo -e "\033[33;1m install unzip command in your system \033[0m"
    exit 1
fi

unzip -qq $OUTPUT_BASENAME_WITH_POSTFIX -d $OUTPUT_BASENAME

DATREE_CONFIG_PATH=~/.datree
mkdir -p $DATREE_CONFIG_PATH

if [[ $osName == "Linux" ]];
then
    sudo rm -f /usr/local/bin/datree
    sudo cp $OUTPUT_BASENAME/datree /usr/local/bin
else
    rm -f /usr/local/bin/datree
    cp $OUTPUT_BASENAME/datree /usr/local/bin
fi

CONFIG_FILE_PATH=$DATREE_CONFIG_PATH/config.yaml
if [ ! -f "$CONFIG_FILE_PATH" ]; then
    echo "token: internal_"$(openssl rand -hex 12) >> $CONFIG_FILE_PATH
fi

rm $OUTPUT_BASENAME_WITH_POSTFIX
rm -rf $OUTPUT_BASENAME

curl -s https://get.datree.io/k8s-demo.yaml > ~/.datree/k8s-demo.yaml
echo -e "[V] Finished Installation"

echo

echo -e "\033[35m Usage: $ datree test ~/.datree/k8s-demo.yaml"

echo -e " Using Helm? => https://hub.datree.io/helm-plugin \033[0m"

echo
