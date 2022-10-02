#!/bin/bash
readonly LAYERS_DIR=$(readlink -f $(dirname $0)/layers/)
readonly OE_INIT_BUILD_ENV=$LAYERS_DIR/poky/oe-init-build-env
readonly PROGNAME=$(basename "$0")
readonly ARGS="$@"
export readonly BB_ENV_PASSTHROUGH_ADDITIONS="CCACHE_TOP_DIR DISTRO DL_DIR MACHINE SSTATE_DIR"

# Project specific
export readonly IMAGE=${IMAGE:=mapio-genimage}
export readonly MACHINE=${MACHINE:=mapio-cm4-64}
export readonly DISTRO=${DISTRO:=mapio}

# Exit on error
set -e

verbose_echo()
{
    if [ -n "${VERBOSE}" ]; then
        echo "$1"
    fi
}

yocto_init() {
    source $OE_INIT_BUILD_ENV

    yocto_layers
}

yocto_layers()
{
    local ret=0

    echo "### Add layers ### "

    local LAYERS=""
    while read layer_conf; do
        LAYERS="$LAYERS $(readlink -f $(dirname $layer_conf)/..)"
    done <<< $(find $LAYERS_DIR/meta-* -name layer.conf)

    bitbake-layers add-layer $LAYERS

    echo "### Show layers ### "
    time bitbake-layers show-layers
    ret=$?

    return ${ret}
}

yocto_build_img()
{
    local ret=0

    echo "### build ${IMAGE} ### "
    time bitbake "${IMAGE}"
    ret=$?

    return ${ret}
}

yocto_build_sdk()
{
    local ret=0

    echo "### build SDK for ${IMAGE} ### "
    time bitbake "${IMAGE}" -c populate_sdk
    ret=$?

    if [ ${ret} -eq 0 ]; then 
        yocto_package_sdk
        ret=$?
    fi

    return ${ret}
}

usage() {
    local ret="$1"
cat <<- EOF
    usage: $PROGNAME options
 
    Program deletes files from filesystems to release space.
    It gets config file that define fileystem paths to work on, and whitelist rules to
    keep certain files.
 
    OPTIONS:
        -c --cmd : commande enable: sync | layers | build | build-sdk | all | bash
        -d --debug: debug
        -h --help: show this help
        -v --verbose: Verbose.
    
    Details commandes:
        - layers:    show layers informations
        - build-img: build Yocto image: ${IMAGE}
        - build-sdk: build Yocto SDK
        - build-all: build Yocto & SDK
        - bash:      start an interactive bash shell

    Examples:
        Run build-img :
        $PROGNAME --cmd build-img
        
        Run build-all:
        $PROGNAME --cmd build-all
 
        Run bash:
        $PROGNAME --cmd bash

EOF
    exit "${ret}"
}

check_parameters()
{
    verbose_echo "CMD: ${CMD}"
    verbose_echo "BASH_CMD: ${BASH_CMD}"

    if [[ -z ${CMD} ]] && [[ -z $BASH_CMD ]]; then
        echo "You must provide a commande"
        usage 1
    fi
}

cmdline() {
    # got this idea from here:
    # http://kirk.webfinish.com/2009/10/bash-shell-script-to-use-getopts-with-gnu-style-long-positional-parameters/
    local arg=
    for arg
    do
        local delim=""
        case "$arg" in
            #translate --gnu-long-options to -g (short options)
            --cmd) args="${args}-c ";;
            --debug) args="${args}-x ";;
            --help) args="${args}-h ";;
            --verbose) args="${args}-v ";;
            #pass through anything else
            *) [[ "${arg:0:1}" == "-" ]] || delim="\""
                args="${args}${delim}${arg}${delim} ";;
        esac
    done

    #Reset the positional parameters to the short options
    eval set -- "${args}"

    while getopts "hvxab:d:c:u:t:n:" OPTION
    do
        case $OPTION in
            c)
                readonly CMD=$OPTARG
                ;;
            d)
                set -x
                ;;
            h)
                usage 0
                ;;
            v)
                readonly VERBOSE=1
                ;;
            *)
            ;;
        esac
    done

    shift $((OPTIND-1))
    BASH_CMD=$@

    check_parameters

    return 0
}

main()
{
    cmdline ${ARGS}

    # Init Yocto build
    yocto_init

    if [[ -n ${CMD} ]]; then
        case "${CMD}" in
            layers)
                yocto_layers || exit $?
            ;;

            build-img)
                yocto_build_img || exit $?
            ;;

            build-sdk)
                yocto_build_sdk || exit $?
            ;;

            build-all)
                yocto_build_img || exit $?
                yocto_build_sdk || exit $?
            ;;

            bash)
                yocto_source
                bash
            ;;

            *)
                echo "Command not supported: ${CMD}"
                usage 1
        esac
    fi

    eval ${BASH_CMD}

    exit 0
}

main

