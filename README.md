# Dotfiles

This repo contains my dotfiles managed by a bare git repo. This is based on a [Nicola Paolucci blogpost](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/), which is based on a [Hacker News comment by StreakyCobra](https://news.ycombinator.com/item?id=11070797).

## Installation

To install your dotfiles on a fresh Linux account, run:

```
curl -Lks https://raw.githubusercontent.com/ericslandry/dotfiles/master/.dotfiles-setup.sh | /bin/bash
```

## Usage

```
dotfiles status
dotfiles add .vimrc
dotfiles commit -avm "Adding .vimrc"
dotfiles push -u origin master
```


