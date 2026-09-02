if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone --bare git@github.com:crstnsz/crstnsz-dotfiles.git $HOME/.dotfiles
  alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  config config --local status.showUntrackedFiles no
  config checkout
fi

