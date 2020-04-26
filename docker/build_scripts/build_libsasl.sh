#!/bin/bash

function check_var {
    if [ -z "$1" ]; then
        echo "required variable not defined"
        #exit 1
    fi
}

function check_sha256sum {
    local fname=$1
    check_var ${fname}
    local sha256=$2
    check_var ${sha256}

    echo "${sha256}  ${fname}" > ${fname}.sha256
    sha256sum -c ${fname}.sha256
    rm -f ${fname}.sha256
}

function do_standard_install {
    ./configure "$@" > /dev/null
    make -j$(nproc) > /dev/null
    make -j$(nproc) install > /dev/null
}

function build_libsasl {
    check_var ${LIBSASL_DOWNLOAD_URL}
    check_var ${LIBSASL_VERSION}
    check_var ${LIBSASL_HASH}
    local rname="cyrus-sasl-${LIBSASL_VERSION}"
    local fname="${rname}.tar.gz"
    curl -fsSLO "${LIBSASL_DOWNLOAD_URL}/${rname}/${fname}"
    check_sha256sum "${fname}" "${LIBSASL_HASH}"
    tar xfz "${fname}"
    (cd "${rname}" && do_standard_install)
    rm -rf "${fname}" "${rname}"
}

build_libsasl
