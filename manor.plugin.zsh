#!/usr/bin/env zsh

if [[ -z $MANOR_INSTALL_LOCATION ]]; then
    MANOR_INSTALL_LOCATION=$(dirname $(readlink -f $0))/src
fi

function manor() {
    if [[ $1 == 'goto' ]]; then
        source $MANOR_INSTALL_LOCATION/util.sh
        cd $MODULES_DIR/$(name_to_dir $2)
    else
        $MANOR_INSTALL_LOCATION/manor $@
    fi
}

fpath+="${0:h}/completion"
