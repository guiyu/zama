#!/bin/bash
# Sepolia 测试网代币领取工具启动脚本 (适用于 macOS/Linux)
# 功能：
# 1. 检查 Python 3.6+ 是否安装
# 2. 检查 web3 依赖是否安装，否则自动安装 requirements.txt
# 3. 启动 sepolia_claimer.py
# 4. 友好提示和错误处理

set -e

# 彩色输出函数
echo_info() { echo -e "\033[1;36m$1\033[0m"; }
echo_error() { echo -e "\033[1;31m$1\033[0m"; }

echo_info "正在启动Sepolia测试网代币领取工具..."
echo

# 检查 Python 3.6+
if ! command -v python3 &>/dev/null; then
    echo_error "错误: 未找到 Python3，请先安装 Python 3.6 或更高版本"
    exit 1
fi
PY_VER=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))')
REQ_VER=3.6
if [[ $(echo -e "$PY_VER\n$REQ_VER" | sort -V | head -n1) != "$REQ_VER" ]]; then
    echo_error "错误: Python 版本需 >= 3.6，当前为 $PY_VER"
    exit 1
fi

# 检查依赖
if ! python3 -m pip show web3 &>/dev/null; then
    echo_info "未检测到 web3，正在安装依赖包..."
    if ! python3 -m pip install -r requirements.txt; then
        echo_error "错误: 依赖包安装失败"
        exit 1
    fi
else
    echo_info "依赖包已安装。"
fi

echo
echo_info "==============================="
echo_info "Sepolia测试网代币领取工具"
echo_info "合约地址: 0x3edf60dd017ace33a0220f78741b5581c385a1ba"
echo_info "网络: Sepolia测试网"
echo_info "==============================="
echo

echo_info "启动程序..."
if ! python3 sepolia_claimer.py; then
    echo_error "\n程序异常退出，按任意键关闭窗口"
    read -n 1 -s
    exit 1
fi 