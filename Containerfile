FROM debian:trixie
ENV NVM_DIR=/root/.nvm
ENV PORT=3000
EXPOSE $PORT

# install necessary dependencies
RUN apt-get update && apt-get install curl unzip jq -y \
    && rm -rf /var/lib/apt/lists/*

# download and unpack the latest Peacock (Linux) release
RUN set -eux; \
    LATEST_PEACOCK_RELEASE=$(curl -fsSL -H 'Accept: application/json' 'https://api.github.com/repos/thepeacockproject/Peacock/releases/latest' | jq -r .tag_name); \
    FOLDER_NAME="Peacock-${LATEST_PEACOCK_RELEASE}-linux"; \
    FILE_NAME="${FOLDER_NAME}.zip"; \
    curl -fsSLJO -H 'Accept: application/octet-stream' "https://github.com/thepeacockproject/Peacock/releases/latest/download/${FILE_NAME}"; \
    unzip -q "${FILE_NAME}" -x '*/PeacockPatcher.exe'; \
    rm "${FILE_NAME}"; \
    mv "${FOLDER_NAME}" peacock

# install nvm
RUN set -eux; \
    LATEST_NVM_RELEASE=$(curl -fsSL -H 'Accept: application/json' 'https://api.github.com/repos/nvm-sh/nvm/releases/latest' | jq -r .tag_name); \
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_NVM_RELEASE}/install.sh" | bash

# install node
RUN bash -c "source $NVM_DIR/nvm.sh && cd /peacock && nvm install"

# set working directory
WORKDIR /peacock

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

# run Peacock
CMD ["node", "--enable-source-maps", "chunk0.js"]
