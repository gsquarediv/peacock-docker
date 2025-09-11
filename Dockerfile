FROM debian:trixie
ARG NODE_VERSION=20
ENV PORTNUMBER=8080

# install curl
RUN apt-get update && apt-get install curl unzip -y

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# set env
ENV NVM_DIR=/root/.nvm

# install node
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION"

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

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
    unzip -q "${FILE_NAME}"; \
    rm "${FILE_NAME}"; \
    mv "${FOLDER_NAME}" peacock

# Set working directory
WORKDIR /peacock

EXPOSE $PORTNUMBER

# Run Peacock
CMD PORT=$PORTNUMBER node --enable-source-maps --harmony chunk0.js --hmr
