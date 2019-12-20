#!/usr/bin/env zsh

MANOR_INSTALL_LOCATION=$(dirname $(readlink -f $0))/src

function manor() {
    $MANOR_INSTALL_LOCATION/manor $@
}

fpath+="${0:h}/completion"
