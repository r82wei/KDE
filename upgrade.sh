#!/bin/bash

# 安裝 kde 腳本
mkdir -p ~/.kde
rm -rf ~/.kde/scripts
rm -rf ~/.kde/kde.sh
cp -r ./scripts ~/.kde/scripts
cp ./kde.sh ~/.kde/kde.sh
