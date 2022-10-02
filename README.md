## Pre-requisites ##

This documentation supports Ubuntu 20.04 LTS version.
However command listed below should work with any recent debian-like Linux
distribution.

### git ###

From https://git-scm.com/:
Git is a free and open source distributed version control system designed to
 handle everything from small to very large projects with speed and efficiency.

To install git:

```bash
  $ sudo apt install git
```

For more informations: https://git-scm.com/

### repo ###

From https://gerrit.googlesource.com/git-repo/:
Repo is a tool built on top of Git. Repo helps manage many Git repositories,
does the uploads to revision control systems, and automates parts of the
development workflow. Repo is not meant to replace Git, only to make it easier
to work with Git. The repo command is an executable Python script that you can
put anywhere in your path.

To install repo:

```bash
  $ mkdir ~/.bin
  $ echo "PATH=~/.bin:\$PATH" >> ~/.bashrc && source ~/.bashrc
  $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
```

For more informations: https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md

### Docker  ###

From https://docs.docker.com/get-started/overview/:
Docker is an open platform for developing, shipping, and running applications.

To install docker:

```bash
  $ sudo apt install docker.io
```

For more informations: https://www.docker.com/

### cqfd ###

From https://github.com/savoirfairelinux/cqfd:
cqfd provides a quick and convenient way to run commands in the current
directory, but within a Docker container defined in a per-project config file.

To install cqfd:

```bash
  $ git clone git@github.com:savoirfairelinux/cqfd.git
  $ cd cqfd/
  $ sudo make install
```

For more information: https://github.com/savoirfairelinux/cqfd

### bmaptool ###

From https://github.com/intel/bmap-tools:
Bmaptool is a generic tool for creating the block map (bmap) for a file and
copying files using the block map. The idea is that large files, like raw
system image files, can be copied or flashed a lot faster and more reliably
with bmaptool than with traditional tools, like dd or cp.

To install bmaptool:

```bash
  $ sudo apt install bmap-tools
```

For more informations:
* https://github.com/intel/bmap-tools
* https://www.yoctoproject.org/docs/latest/dev-manual/dev-manual.html#flashing-images-using-bmaptool

## Get the project ##

Refer to https://github.com/pcurt/mapio-manifest

### Build cqfd docker image ###

This has to be done only once unless the Dockerfile is modified:

```bash
  $ cqfd init
```

## Build project ##

To build MAPIO project for MAPIO board:

```bash
  $ cqfd
```

## Advanced build setup ##

### Launch commands through cqfd container ###

Commands can be ran inside cqfd containers as for classical Docker containers.

'cqfd run \<command\>':

```bash
  $ cqfd run bash
  $ cqfd run ls
  $ cqfd run whoami
```

### Launch Yocto commands through cqfd container ###

Yocto commands are wrapped by 'build.py':

```bash
  $ cqfd run ./build.py bitbake -e cortex-genimage
  $ cqfd run ./build.py bitbake virtual/kernel
  $ cqfd run ./build.py bash
```

### Advanced build confiuration ###

By default build wrapper 'build.py' is building 'core-image-minimal' Yocto
image.
To override image built, export or set in command line the IMAGE variable:

```bash
  $ cqfd run IMAGE=cortex-genimage ./build.py
```

MACHINE and DISTRO are respectively set by default to 'x86_64' and 'poky' by
bitbake and can be overriden too:

```bash
  $ cqfd run MACHINE=mapio-cm4-64 DISTRO=mapio IMAGE=mapio-genimage ./build.py
```

## Flash project on target ##

### Create SD card ###

This chapter assumes that you have a working SD card reader.

Use 'bmaptool' to copy the previously built image on the SD card (replace 'sdX'
by your SD card device name):

```bash
  sudo bmaptool copy build/tmp/deploy/images/mapio-cm4-64/mapio-genimage-mapio-cm4-64.img.bmap /dev/sdX
```
