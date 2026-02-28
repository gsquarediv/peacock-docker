FROM debian:trixie-slim
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ENV PORT=3000
EXPOSE $PORT

# install necessary dependencies
RUN apt-get update && apt-get install curl unzip jq -y \
    && rm -rf /var/lib/apt/lists/*

# download and unpack the latest Peacock (Linux) release
RUN set -eux; \
    LATEST_RELEASE=$(curl -fsSL -H 'Accept: application/json' 'https://api.github.com/repos/thepeacockproject/Peacock/releases/latest' | jq -r .tag_name); \
    FOLDER_NAME="Peacock-${LATEST_RELEASE}-linux"; \
    FILE_NAME="${FOLDER_NAME}.zip"; \
    curl -fsSLJO -H 'Accept: application/octet-stream' "https://github.com/thepeacockproject/Peacock/releases/latest/download/${FILE_NAME}"; \
    unzip -q "${FILE_NAME}" -x '*/PeacockPatcher.exe'; \
    rm "${FILE_NAME}"; \
    mv "${FOLDER_NAME}" peacock

# install node
RUN set -eux; \
    NODE_VERSION=$(cat peacock/.nvmrc); \
    NODE_DIR=/opt/nodejs; \
    mkdir ${NODE_DIR}; \
    case "${TARGETARCH}" in \
        amd64) NODE_ARCH='x64' OPENSSL_ARCH='linux-x86_64';; \
        arm64) NODE_ARCH='arm64' OPENSSL_ARCH='linux-aarch64';; \
    esac; \
    NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-${NODE_ARCH}.tar.gz"; \
    curl -fsSL "${NODE_URL}" | tar --strip-components=1 -C ${NODE_DIR} -zxf -; \
    ln -s "${NODE_DIR}/bin/node" /usr/local/bin/node; \
    [ -n "${OPENSSL_ARCH+set}" ] && find "${NODE_DIR}/include/node/openssl/archs" -mindepth 1 -maxdepth 1 ! -name "$OPENSSL_ARCH" -exec rm -rf {} +; \
    node --version

WORKDIR /peacock

ENTRYPOINT ["node"]

# run Peacock
CMD ["--enable-source-maps", "chunk0.js"]
