FROM debian:trixie
ENV NVM_DIR=/root/.nvm
ENV PORT=3000
EXPOSE $PORT

# install curl
RUN apt-get update && apt-get install curl unzip -y

# Download and unpack the latest Peacock (Linux) release
RUN set -eux; \
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/thepeacockproject/Peacock/releases/latest \
      | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/'); \
    FOLDER_NAME="Peacock-${LATEST_RELEASE}-linux"; \
    FILE_NAME="${FOLDER_NAME}.zip"; \
    echo "Downloading $FILE_NAME from release $LATEST_RELEASE"; \
    curl -sSL -H "Accept: application/octet-stream" \
      -o "${FILE_NAME}" \
      "https://github.com/thepeacockproject/Peacock/releases/download/${LATEST_RELEASE}/${FILE_NAME}"; \
    unzip -q "${FILE_NAME}" -x '*/PeacockPatcher.exe'; \
    rm "${FILE_NAME}"; \
    mv "${FOLDER_NAME}" peacock

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# install node
RUN bash -c "source $NVM_DIR/nvm.sh && cd /peacock && nvm install"

# Set working directory
WORKDIR /peacock

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

# Run Peacock
CMD ["node", "--enable-source-maps", "chunk0.js"]
