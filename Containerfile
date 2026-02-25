FROM debian:trixie
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

# install node
RUN set -eux; \
    node_version=$(cat peacock/.nvmrc); \
    node_url="https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.gz"; \
    mkdir -p /opt/nodejs; \
    curl -fsSL $node_url | tar --strip-components=1 -C /opt/nodejs -zxf -; \
    ln -s /opt/nodejs/bin/node /usr/local/bin/node

WORKDIR /peacock

ENTRYPOINT ["node"]

# run Peacock
CMD ["--enable-source-maps", "chunk0.js"]
