#!/bin/bash

GITHUB_USERNAME=ericslandry
GITHUB_REPONAME=dotfiles
GIT_USER_NAME="Eric Landry"
GIT_USER_EMAIL="eric.s.landry@gmail.com"

git clone --bare https://github.com/$GITHUB_USERNAME/$GITHUB_REPONAME.git $HOME/.dotfiles-tmp
rsync --recursive --verbose --exclude '.git' $HOME/.dotfiles-tmp/ $HOME/
rm --recursive $HOME/dotfiles-tmp
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
dotfiles config user.name "$GIT_USER_NAME"
dotfiles config user.email "$GIT_USER_EMAIL"


