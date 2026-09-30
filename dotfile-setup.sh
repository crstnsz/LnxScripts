if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone --bare git@github.com:crstnsz/crstnsz-dotfiles.git $HOME/.cfg
  if [ -x "/usr/bin/git" ]; then
      alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
  elif [ -x "/mingw64/bin/git" ]; then
      alias config='/mingw64/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
  fi

  config config --local status.showUntrackedFiles no
  config checkout
fi

