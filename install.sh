#!/bin/bash

# 安裝 kde 腳本
source ./upgrade.sh

# 設定 alias
KDE_SCRIPT='~/.kde/kde.sh'
# 判斷 shell 類型，並且設定 alias 到 shell alias
if [[ "$SHELL" == "/bin/bash" ]]; then
    echo "alias kde='${KDE_SCRIPT}'" >> ~/.bash_aliases
    source ~/.bash_aliases
elif [[ "$SHELL" == "/bin/zsh" ]]; then
    echo "alias kde='${KDE_SCRIPT}'" >> ~/.zshrc
    source ~/.zshrc
fi

