#!/bin/bash



# 案例
# https://github.com/nanasess/setup-chromedriver/blob/master/lib/setup-chromedriver.sh
# https://stackoverflow.com/questions/70341964/running-selenium-webdriver-in-github-actions-for-unit-tests


# 如果是在GitHub action中直接运行此文件 则需要注释，如果是在GitHub action中通过js调用此文件则需去掉注释例如使用https://github.com/nanasess/setup-chromedriver/blob/master/lib/setup-chromedriver.js
# set -eo pipefail

CURL="curl --silent --location --fail --retry 10"
JSON_URL=https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json

VERSION=$1
ARCH=$2

if [[ "${ARCH}" =~ ^linux64 ]]; then
    CHROMEAPP=google-chrome
    echo "默认已经安装过了 谷歌浏览器"
    echo "CHROME VERSION " "${CHROMEAPP}" --version  $("${CHROMEAPP}" --version )
    echo " "
    cat /etc/apt/sources.list.d/google.list
    echo " "
    # 超级管理员
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
    echo " "
    echo "-y  ${apps[@]} "
    echo " "
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

echo "Installing chromedriver ..."
echo ""
if ((CHROME_VERSION < 115)); then
    if [[ -z "${VERSION}" ]]; then
        URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}"
        echo "Downloading ${URL}..."
        VERSION=$(${CURL} "${URL}")
        echo "VERSION=${VERSION}"
    fi
    echo "Installing ChromeDriver ${VERSION} for ${ARCH}"
    URL="https://chromedriver.storage.googleapis.com/${VERSION}/chromedriver_${ARCH}.zip"
    echo "Downloading ${URL}..."
    ${CURL} -o chromedriver.zip "${URL}"
    unzip -o -q chromedriver.zip
    sudo mv chromedriver /usr/local/bin/chromedriver
    rm -f chromedriver.zip
    exit
fi

if [[ -z "${VERSION}" ]]; then
    VERSION=$("${CHROMEAPP}" --version | cut -f 3 -d ' ')
    echo "VERSION=${VERSION}"
fi
if [[ "${ARCH}" =~ ^mac64 ]]; then
    ARCH="mac-x64"
fi

echo "Downloading ${JSON_URL}..."
JSON=$(${CURL} "${JSON_URL}")
JQ=".versions[] | select(.version == \"${VERSION}\") | .downloads.chromedriver[] | select(.platform == \"${ARCH}\") | .url"
URL=$(jq -r "${JQ}" <<<"${JSON}")
if [[ -z "${URL}" ]]; then
    echo "Falling back to latest version of ChromeDriver for ${ARCH}"
    VERSION3=$(cut -d '.' -f1-3 <<<"${VERSION}")
    echo "VERSION3=${VERSION3}"
    JQ2="[ .versions[] | select(.version | startswith(\"${VERSION3}.\")) ] | last | .version"
    VERSION=$(jq -r "${JQ2}" <<<"${JSON}")
    echo "VERSION=${VERSION}"
    JQ3=".versions[] | select(.version == \"${VERSION}\") | .downloads.chromedriver[] | select(.platform == \"${ARCH}\") | .url"
    URL=$(jq -r "${JQ3}" <<<"${JSON}")
fi
echo "Installing ChromeDriver ${VERSION} for ${ARCH}"
echo "Downloading ${URL}..."
${CURL} -o chromedriver.zip "${URL}"
unzip -o -q chromedriver.zip
sudo mv "chromedriver-${ARCH}/chromedriver" /usr/local/bin/chromedriver
rm -fr chromedriver.zip chromedriver-*

echo " "
chromedriver -version
echo " "
which chromedriver
echo " "
echo " "





