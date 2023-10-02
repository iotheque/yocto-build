FROM ubuntu:20.04

# Default locales variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# No frontend for apt/dpkg commands
ENV DEBIAN_FRONTEND=noninteractive


# Install dependencies
RUN apt-get update \
    && apt-get install -y -q \
        build-essential \
        chrpath \
        cpio \
        debianutils \
        diffstat \
        gawk \
        gcc \
        git \
        iputils-ping \
        liblz4-tool \
        libegl1-mesa \
        libncurses5-dev \
        libsdl1.2-dev \
        locales \
        mesa-common-dev \
        pylint3 \
        python3 \
        python3-git \
        python3-jinja2 \
        python3-pexpect \
        python3-pip \
        python3-subunit \
        socat \
        texinfo \
        tmux \
        unzip \
        wget \
        xterm \
        xz-utils \
        zstd

# Configure locales
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN pip install --no-cache-dir --upgrade pip \
  && pip install kas==3.1

# For cache NFS binding
RUN git config --system --add safe.directory '*'

# Install yq tool
RUN wget https://github.com/mikefarah/yq/releases/download/v4.27.5/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
