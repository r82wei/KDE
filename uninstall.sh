#!/bin/bash

# 檢查 /usr/local/lib/kde 是否存在且非空
if [[ -d "/usr/local/lib/kde" ]]; then
    rm -rf /usr/local/lib/kde
fi

# 檢查 /usr/local/bin/kde 是否存在且非空
if [[ -L "/usr/local/bin/kde" ]]; then
    rm -rf /usr/local/bin/kde
fi