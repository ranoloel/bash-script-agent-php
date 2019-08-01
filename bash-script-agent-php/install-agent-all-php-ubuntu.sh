#!/bin/bash
AGENT_ARCHIVE="$1"
PATCH_ARCHIVE="$2"
AGENT_KEY="$3"
AGENT_ENVIRONMENT="$4"
AGENT_DL_ENV="$5"
PROFILER_DESC="$6"
CURRENT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [ "$#" -eq 5 ]; then
    if [ "$1" == "*.tar.gz" ]; then
        AGENT_ARCHIVE="$1"
        PATCH_ARCHIVE=""
    else
        PATCH_ARCHIVE="$1"
        AGENT_ARCHIVE=""
    fi
    AGENT_KEY="$2"
    AGENT_ENVIRONMENT="$3"
    AGENT_DL_ENV="$4"
    # PROFILER_DESC="$5"
fi

if [ "$#" -eq 4 ]; then
    AGENT_DL_ENV="qa"

    if [ "$1" == "*.tar.gz" ]; then
        AGENT_ARCHIVE="$1"
        PATCH_ARCHIVE=""
    elif [ "$1" == "*.zip" ]; then
        PATCH_ARCHIVE="$1"
        AGENT_ARCHIVE=""
    else
        AGENT_DL_ENV="$1"
        PATCH_ARCHIVE=""
        AGENT_ARCHIVE=""
    fi

    AGENT_KEY="$2"
    AGENT_ENVIRONMENT="$3"
    # PROFILER_DESC="$4"
fi

if [ "$#" -eq 3 ]; then
    AGENT_ARCHIVE=""
    PATCH_ARCHIVE=""
    AGENT_KEY="$1"
    AGENT_ENVIRONMENT="$2"
    AGENT_DL_ENV="qa"
    # PROFILER_DESC="$3"
fi

if [ ! -f ~/stackify.tar.gz ] && [ "$AGENT_ARCHIVE" == "" ]; then
    echo "Download agent"
    cd ~ && wget https://${AGENT_DL_ENV}.stackify.com/Account/AgentDownload/Linux --output-document=stackify.tar.gz
    AGENT_ARCHIVE=~/stackify.tar.gz
elif [ -f ~/stackify.tar.gz ]; then
    AGENT_ARCHIVE=~/stackify.tar.gz
fi

if [ -d ~/stackify-agent-install-32bit ]; then
    echo "Remove current agent"
    cd ~/stackify-agent-install-32bit && ./agent-install.sh --remove
    cd ~ && rm -rf ~/stackify-agent-install-32bit
fi

if [ ! -f $AGENT_ARCHIVE ]; then
    echo "Failed to download the agent or agent archive does not exists : $AGENT_ARCHIVE"
    exit 1
else
    echo "Installing "
    if [ ! -d ~/stackify-agent-install-32bit ]; then
        echo "No stackify agent installer folder. Creating.. "
        mkdir -p  stackify-agent-install-32bit
    fi
    cd ~ && tar -zxvf $AGENT_ARCHIVE stackify-agent-install-32bit
    echo "Extraction status: $?"
    if [ $? = 0 ]; then
        echo "Extracting tar file"
        cd ~/stackify-agent-install-32bit && ./agent-install.sh --key $AGENT_KEY --environment "$AGENT_ENVIRONMENT"
    else
        echo "Something went wrong during the extraction, aborting."
        exit 1
    fi
fi

echo "Present or current working directory: $(pwd)"

if [ "$(pwd)" != "${CURRENT_DIRECTORY}" ]; then
    echo "Changing current working directory: $(pwd) -> ${CURRENT_DIRECTORY}"
    cd ${CURRENT_DIRECTORY}
# fi

# # if [ "$PATCH_ARCHIVE" != "" ]; then
#     echo "Patch archive availble - $PATCH_ARCHIVE"
#     ./install-new-patch.sh "$PATCH_ARCHIVE"
# fi

# ./clear-stackify-php-settings.sh
# echo "Profiler Description - $PROFILER_DESC"
# echo "Profiler Environment - $AGENT_ENVIRONMENT"
# ./setup-php.sh "$PROFILER_DESC" "$AGENT_ENVIRONMENT"
exit 0