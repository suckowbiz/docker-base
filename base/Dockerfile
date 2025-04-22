FROM ubuntu:24.04
LABEL maintainer="Tobias Suckow <tobias@suckow.biz>"

# Set environment variables to ensure non-interactive installs and proper locale settings.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        language-pack-en-base \
        curl \
        gnupg \
        software-properties-common \
        unzip \
        xz-utils \
        gosu && \
    rm -rf /var/lib/apt/lists/*

COPY context /
