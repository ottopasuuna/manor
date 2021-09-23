#!/bin/bash

########### Constants ###########
if [[ -z $MODULES_DIR ]]; then
    if [[ -z $XDG_DATA_HOME ]]; then
	    XDG_DATA_HOME="$HOME/.local/share"
    fi
    MODULES_DIR="$XDG_DATA_HOME/manor"
fi
MANOR_DEFAULT_MODULE_LIST="enabled_modules"
if [[ -z $MODULES_LIST ]]; then
    MODULES_LIST="$MODULES_DIR/$MANOR_DEFAULT_MODULE_LIST"
fi

########## Utility functions #############
function ensure_modules_dir_exists() {
    if [[ ! -d $MODULES_DIR ]]; then
        mkdir $MODULES_DIR
    fi
}

function url_to_name() {
    url=$1
    if echo $url | grep -q 'git@.*\.git' - ; then
        name=`echo $url | cut -d '/' -f 2 | sed 's/.git//'`
        echo $name
    else
        echo $url
    fi
}

function name_to_git_url() {
    name=$1
    printf "git@github.com:%s.git" $name
}

function name_to_dir() {
    name=$1
    echo $name | sed -r 's/.*\///'
}

function read_modules_list() {
    if [[ -f $MODULES_LIST ]]; then
        echo $(grep -v "^#.*" $MODULES_LIST) | sed 's/"//g'
    elif [[ "$(declare -p MODULES_LIST)" =~ "declare -a" ]]; then
        echo ${MODULES_LIST[@]} | sed 's/"//g"'
    else
        echo "MODULES_LIST: $MODULES_LIST does not exist!"
        exit 1
    fi
}
