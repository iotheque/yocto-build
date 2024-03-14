FROM ubuntu:22.04

# Default locales variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# No frontend for apt/dpkg commands
ENV DEBIAN_FRONTEND=noninteractive


# Install dependencies
RUN apt-get update \
    && apt-get install -y -q \
        gawk \
        wget \
        git \
        diffstat \
        unzip \
        texinfo \
        gcc \
        build-essential \
        chrpath \
        socat \
        cpio \
        python3 \
        python3-pip \
        python3-pexpect \
        xz-utils \
        debianutils \
        iputils-ping \
        python3-git \
        python3-jinja2 \
        libegl1-mesa \
        libsdl1.2-dev \
        python3-subunit \
        mesa-common-dev \
        zstd \
        liblz4-tool \
        file \
        locales \
        libacl1 \
        sudo \
        tmux


# Configure locales
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN pip install --no-cache-dir --upgrade pip \
  && pip install kas==4.1
