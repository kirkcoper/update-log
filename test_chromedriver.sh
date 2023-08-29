#!/bin/bash





# set -eo pipefail

CURL="curl --silent --location --fail --retry 10"
JSON_URL=https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json

# VERSION=$1
# ARCH=$2

# if [[ "${ARCH}" =~ ^linux64 ]]; then
#     CHROMEAPP=google-chrome
#     sudo=$(command -v sudo)
#     APP="${CHROMEAPP}"
#     if ! dpkg -s "${APP}" >/dev/null; then
#         ${sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A040830F7FAC5991
#         echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | ${sudo} tee /etc/apt/sources.list.d/google.list
#         APP=google-chrome-stable
#     fi
#     apps=()
#     test -z "${sudo}" && apps+=(sudo)
#     type -a curl > /dev/null 2>&1 || apps+=(curl)
#     type -a "${CHROMEAPP}" > /dev/null 2>&1 || apps+=("${APP}")
#     type -a jq > /dev/null 2>&1 || apps+=(jq)
#     type -a unzip > /dev/null 2>&1 || apps+=(unzip)
#     if (("${#apps[@]}")); then
#         echo "Installing ${apps[*]}..."
#         export DEBIAN_FRONTEND=noninteractive
#         ${sudo} apt-get update
#         ${sudo} apt-get install -y "${apps[@]}"
#     fi
# fi

# if [[ "${ARCH}" =~ ^mac64 ]]; then
#     CHROMEAPP="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
# fi

# if [[ "${VERSION}" ]]; then
#     CHROME_VERSION=$(cut -d '.' -f 1 <<<"${VERSION}")
# else
#     CHROME_VERSION=$("${CHROMEAPP}" --version | cut -f 3 -d ' ' | cut -d '.' -f 1)
# fi
echo "JSON_URL  ${JSON_URL}"
echo ""
which "${VERSION}"
echo ""
echo ""
echo ""
