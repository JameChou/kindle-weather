#!/bin/sh

# --- 配置 ---
SCRIPT_NAME="sync_screensaver_png.sh"
LOG_FILE="/mnt/us/extensions/kind-bash/sync.log"

# --- 检查逻辑 ---

# 检查同步脚本是否正在执行 (ps 结果中过滤 grep 自己)
IS_SYNC_RUNNING=$(ps | grep "$SCRIPT_NAME" | grep -v "grep" | wc -l)

# --- 屏幕反馈 ---
# 使用 eips 命令在屏幕中央显示状态
eips 10 30 "--- Sync screensaver png service status ---"

if [ "$IS_SYNC_RUNNING" -gt 0 ]; then
    eips 10 32 "Sync Task: [RUNNING]"
    echo "$(date): Check - Sync is active" >> $LOG_FILE
else
    eips 10 32 "Sync Task: [IDLE]"
fi

eips 10 36 "Check Log for details."