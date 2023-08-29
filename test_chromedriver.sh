#!/bin/bash



# 案例
# https://github.com/nanasess/setup-chromedriver/blob/master/lib/setup-chromedriver.sh

# 如果是在GitHub action中直接运行此文件 则需要注释，如果是在GitHub action中通过js调用此文件则需去掉注释例如使用https://github.com/nanasess/setup-chromedriver/blob/master/lib/setup-chromedriver.js
# set -eo pipefail

CURL="curl --silent --location --fail --retry 10"
JSON_URL=https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json

VERSION=$1
ARCH=$2

if [[ "${ARCH}" =~ ^linux64 ]]; then
    CHROMEAPP=google-chrome
    sudo=$(command -v sudo)
    APP="${CHROMEAPP}"
    if ! dpkg -s "${APP}" >/dev/null; then
        ${sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A040830F7FAC5991
        echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | ${sudo} tee /etc/apt/sources.list.d/google.list
        APP=google-chrome-stable
    fi
    apps=()
    test -z "${sudo}" && apps+=(sudo)
    type -a curl > /dev/null 2>&1 || apps+=(curl)
    type -a "${CHROMEAPP}" > /dev/null 2>&1 || apps+=("${APP}")
    type -a jq > /dev/null 2>&1 || apps+=(jq)
    type -a unzip > /dev/null 2>&1 || apps+=(unzip)
    if (("${#apps[@]}")); then
        echo "Installing ${apps[*]}..."
        export DEBIAN_FRONTEND=noninteractive
        # 更新库
        ${sudo} apt-get update
        echo " "
        # 安装 软件
        echo "${sudo} apt-get install -y  ${apps[@]} "
        echo " "
        ${sudo} apt-get install -y "${apps[@]}"
    fi
fi

if [[ "${ARCH}" =~ ^mac64 ]]; then
    CHROMEAPP="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
fi

if [[ "${VERSION}" ]]; then
    # 如果传版本参数了 则用制定的版本参数
    CHROME_VERSION=$(cut -d '.' -f 1 <<<"${VERSION}")
else
    CHROME_VERSION=$("${CHROMEAPP}" --version | cut -f 3 -d ' ' | cut -d '.' -f 1)
fi
echo "JSON_URL  ${JSON_URL}"
echo ""
echo "CHROME_VERSION  ${CHROME_VERSION}"
echo ""
echo "CHROME_VERSION " "${CHROMEAPP}" --version  $("${CHROMEAPP}" --version )
echo ""
which "${CHROMEAPP}"
echo ""
echo "VERSION ${VERSION}"
echo ""
echo "ARCH ${ARCH}"
echo ""










