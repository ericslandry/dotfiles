curl -Lks https://raw.githubusercontent.com/ericslandry/dotfiles/master/.dotfiles-setup.sh | /bin/bash


16  git init --bare $HOME/.dotfiles
   17  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
   18  dotfiles
   19  dotfiles config status.showUntrackedFiles no
   20  dotfiles status
   21  ll
   22  rm -rf .dotfiles/
   23  history
   24  git clone --bare https://github.com/ericslandry/dotfiles.git $HOME/.dotfiles
   25  alias
   26  ll .dotfiles/
   27  ll
   28  dotfiles add .bashrc
   29  dotfiles commit -avm "Initial commit"
   30  git config user.name "ericslandry"
   31  dotfiles config user.name "ericslandry"
   32  dotfiles config user.email "eric.s.landry@gmail.com"
   33  dotfiles commit -avm "Initial commit"
   34  dotfiles push
   35  git version
   36  git config --global push.default simple
   37  dotfiles config --global push.default simple
   38  dotfiles push
   39  dotfiles push -u origin master
   40  history
   41  vi README.md
   42  history > README.md 
