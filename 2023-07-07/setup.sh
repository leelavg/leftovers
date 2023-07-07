#!/bin/bash

# Break on failures
set -e
set -o pipefail

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Logging to file and displaying on terminal
# https://unix.stackexchange.com/questions/323142/send-to-log-and-display-on-console
TIME=$(date +%b_%d_%y-%H-%M-%S)
exec 3<&1
coproc mytee { tee $ABSOLUTE_PATH/setup_$TIME.log >&3; }
exec >&${mytee[1]} 2>&1
echo "BEGIN ${SCRIPT_NAME%.sh}"

# Symlinks
[ -L $HOME/.dotfiles ] && rm $HOME/.dotfiles
ln -sfv $ABSOLUTE_PATH/config $HOME/.dotfiles

for file in $HOME/.dotfiles/*; do
  name=$(basename $file)
  if ! [[ $name =~ \.d$ || $name =~ ^_ ]]; then
    ln -sfv $HOME/.dotfiles/$name $HOME/.$name
  fi
done

# Creating required directories
# Nvim
mkdir -pv $HOME/.config/nvim && ln -sfv $HOME/.init.vim $HOME/.config/nvim/init.vim
# Kitty
rm -f $HOME/.config/kitty/kitty.conf
mkdir -pv $HOME/.config/kitty && ln -sfv $HOME/.kitty.conf $HOME/.config/kitty/kitty.conf
# TPM
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &>/dev/null
# bpython
mkdir -pv $HOME/.config/bpython
ln -sfv $HOME/.bpython $HOME/.config/bpython/config
ln -sfv $HOME/.bpython.theme $HOME/.config/bpython/bpython.theme

# Install required binaries
# TODO: jump, k3d, kubctx, kubens, ansible, hugo, tmux, webify etc
# bins=@(kitty fzf neovim bat)
# for bin in ${bins[@]};
# do
#     if ! command -v $bin;
#     then
#         sudo dnf install $bin -y
#     fi
# done

# Install Python provider for NeoVim
if ! grep pynvim <<<$(pip list); then
  pip install pynvim --user
fi

# TODO: Run `packfull` and `updateremoteplugins` on neovim start up

echo "${SCRIPT_NAME%.sh} END"

# find . -type f -print0 -exec dos2unix {} + # Convert scripts written in WSL/Windows to change to Unix line endings
# install `fzf` using `git` method and link minpac path to ~/.fzf
