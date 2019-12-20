#!/usr/bin/env zsh

MANOR_INSTALL_LOCATION=$(dirname $(readlink -f $0))

function manor() {
    $MANOR_INSTALL_LOCATION/manor $@
}
