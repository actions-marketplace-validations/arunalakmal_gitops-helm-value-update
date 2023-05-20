#!/bin/bash

BOT_NAME=$1
HELM_VARIABLE=$2
HELM_VALUE=$3
HELM_VALUE_FILE_PATH=$4
HELM_VALUE_FILE_NAME=$5
VERSION=$6   #v4.30.5

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(pwd)

function update_helm_value {
    git config --global user.name "${BOT_NAME}"
    git config --global user.email "${BOT_NAME}@email.com"
    git pull
    pushd ${HELM_VALUE_FILE_PATH}
    yq -i ".$HELM_VARIABLE = \"$HELM_VALUE\"" ${HELM_VALUE_FILE_NAME}
    popd
    rm -rf {install-man-page.sh,yq,yq.1,yq_linux_amd64.tar.gz}
    git add .
    git commit -m "Helm values updated with the new value ${HELM_VALUE}"
    git push
}

function setup_yq {
    case $(uname -m) in
    x86_64)
        ARCH=amd64
        ;;
    arm64|aarch64)
        ARCH=arm64
        ;;
    ppc64le)
        ARCH=ppc64le
        ;;
    s390x)
        ARCH=s390x
        ;;
    *)
        ARCH=amd64
        ;;
    esac

    OPSYS=windows
    if [[ "$OSTYPE" == linux* ]]; then
    OPSYS=linux
    elif [[ "$OSTYPE" == darwin* ]]; then
    OPSYS=darwin
    fi

    curl -sLO "https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_${OPSYS}_${ARCH}.tar.gz"
    tar zxf ./yq_${OPSYS}_${ARCH}.tar.gz
    mv yq_${OPSYS}_${ARCH} yq
    #$(pwd)/yq --version 
}

if test "$#" -ne 6; then
    echo "Invalid number of Arguments, plesase specify the correct number of arguments"
    echo "Please refer https://github.com/arunalakmal/gitops-helm-value-update#readme for more information."
    exit 1
fi
# elif [[ $(pwd)/yq  ]]; then
#     echo "yq already installed"
#     update_helm_value
# else
setup_yq && update_helm_value
# fi