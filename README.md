Manor
========
Just another dotfile manager. Work in progress, but aims to be fairly minimal.

Manor clones git repositories storing dotfiles and handles setting up symlinks.
Symlink locations are defined manually, allowing you to specify exactly where
config files are stored. Manor makes it easy to install and uninstall configurations.
It can be run as a stand alone executable or as a shell plugin (zsh supported currently).

Currently supports tab completion for Zsh.

### Usage:

Subcommands:
- add        -- Add a file to a module
- git        -- Run a git command on all modules
- goto       -- cd into a module directory (supported as a shell plugin only)
- info       -- Display information on installed modules
- install    -- Install modules
- list       -- List available modules
- uninstall  -- Uninstall modules
- update     -- Pull updates for modules

"Modules" are git repositories with a `config.sh` script at the root.
A `config.sh` script looks like this:
```
description="Vim/Neovim config"

link_map=(
    [vim]=$HOME/.vim
    [vimrc]=$HOME/.vimrc
)

__install__() {
    nvim '+PlugInstall' '+qa' && pip3 install neovim || vim '+PlugInstall' '+qa'
    ln -s $HOME/.vim $HOME/.config/nvim
}
```

Create a file called `enabled_modules` in `$XDG_DATA_HOME/manor` that contains github entries like so:
```
"ottopasuuna/dot-vim"
"ottopasuuna/dot-zsh"
"ottopasuuna/dot-misc"
"ottopasuuna/dot-xorg"
"ottopasuuna/dot-awesome"
"ottopasuuna/dot-systemd"
```
and run `manor install`. This will clone all the repos and set up symlinks as
defined in the `config.sh` files in each module.

There are a few configuration varaibles available:
- `$MANOR_INSTALL_LOCATION`: Where the manor executable is located
- `$MODULES_DIR`: Where to store modules. Defaults to `$XDG_DATA_HOME/manor`
- `$MODULES_LIST`: Path to the file listing the modules to install. Defaults to `$MODULES_DIR/enabled_modules`

## Future work
- Support using specific git branches
- Currently implemented in Bash, might switch to POSIX shell for portablility,
  or Perl/Python because I don't care for shell syntax...
