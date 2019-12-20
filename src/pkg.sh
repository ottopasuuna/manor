#!/bin/bash

CONFIG_FILE='config.sh'

typeset -A link_map

if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE
else
    echo "No $CONFIG_FILE file found"
    exit 1
fi

function call_if_defined() {
    if [[ -n "$(declare -f $1)" ]]; then
        $1
    fi
}

function print_link_map() {
    echo "Link Map: {"
    for src in "${!link_map[@]}"; do
        dest="${link_map[$src]}"
        src="$PWD/$src"
        echo "  $src -> $dest"
    done
    echo "}"
}

function info_pkg() {
    echo "Description: $description"
}

function install_pkg() {
    for dir in "${ensure_dirs[@]}"; do
        if [[ ! -d $dir ]]; then
            echo "Creating $dir"
            mkdir -p $dir
        fi
    done
    for src in "${!link_map[@]}"; do
        dest="${link_map[$src]}"
        src="$PWD/$src"
        if [[ ! -e $dest ]]; then
            echo "$src -> $dest"
            ln -s $src $dest
        else
            echo "$dest already exists, skipping"
        fi
    done
    call_if_defined __install__
}

function uninstall_pkg() {
    for src in "${!link_map[@]}"; do
        dest="${link_map[$src]}"
        if [[ -h $dest ]]; then
            echo "unlinking $dest"
            unlink $dest
        fi
    done
    call_if_defined __uninstall__
}

function update_pkg() {
    git pull
}


############ Main entry ############

args=("$@")
cmd_args=("${args[@]:1}")

if [[ $# -eq 0 ]]; then
    subcommand='info'
else
    subcommand=$1
fi

case $subcommand in
    'info')
        info_pkg ;;
    'install')
        install_pkg ;;
    'update')
        update_pkg ;;
    'uninstall')
        uninstall_pkg ;;
    'show-links')
        print_link_map ;;
    *)
        echo "Invalid command" ;;
esac

