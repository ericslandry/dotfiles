#!/bin/bash
# One-time setup script based on https://bitbucket.org/durdn/cfg/raw/master/.bin/install.sh
GITHUB_USERNAME=ericslandry
GITHUB_REPONAME=dotfiles
GIT_USER_NAME="Eric Landry"
GIT_USER_EMAIL="eric.s.landry@gmail.com"

# TODO: Prompt user to confirm destination

git clone --bare https://github.com/$GITHUB_USERNAME/$GITHUB_REPONAME.git $HOME/.dotfiles
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p $HOME/.dotfiles/backup
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
else
  echo "Backing up pre-existing dot files.";
  # TODO: Improve merging of pre-existing files
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles/backup/{}
fi;
echo "Try check out again"
dotfiles checkout

source $HOME/.bashrc

# Don't pass --global param to avoid messing up your "real" git
dotfiles config status.showUntrackedFiles no
dotfiles config push.default simple
dotfiles config user.name "$GIT_USER_NAME"
dotfiles config user.email "$GIT_USER_EMAIL"

