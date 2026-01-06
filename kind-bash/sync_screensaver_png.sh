#!/bin/sh

# --- 配置区 ---
IMAGE_URL="http:://192.168.0.114:3000/screenshot"
SAVE_PATH="/mnt/us/screenshots/screenshot.png"
LOG_FILE="/mnt/us/extensions/kind-bash/sync.log"

# 记录开始时间
echo "$(date): Start Sync Service" >> $LOG_FILE

# --- 1. 开启 WiFi ---
echo "Turning on WiFi..." >> $LOG_FILE
lipc-set-prop com.lab126.wifid enable 1

# --- 2. 等待 WiFi 连接成功 ---
# 循环检测连接状态，最多等待 60 秒
CONNECTED=0
for i in $(seq 1 60); do
    # 获取当前连接状态
    STATE=$(lipc-get-prop com.lab126.wifid cmState)
    if [ "$STATE" = "CONNECTED" ]; then
        echo "WiFi connected (cost ${i}s)" >> $LOG_FILE
        CONNECTED=1
        break
    fi
    sleep 1
done

# --- 3. 执行下载 ---
if [ $CONNECTED -eq 1 ]; then
    # 给网络 2 秒缓冲时间确保 DNS 解析可用
    sleep 2

    # 下载图片
    wget "$IMAGE_URL" -O "$SAVE_PATH.tmp"

    if [ $? -eq 0 ]; then
        mv "$SAVE_PATH.tmp" "$SAVE_PATH"
        echo "Has downloaded the screen png file, and has already updated the file." >> $LOG_FILE

        # 如果安装了 LinkSS，尝试通知它刷新索引
        # if [ -f /mnt/us/linkss/bin/utils/refresh_screensavers.sh ]; then
            # /bin/sh /mnt/us/linkss/bin/utils/refresh_screensavers.sh
        # fi
    else
        echo "Failed, check the URL." >> $LOG_FILE
    fi
else
    echo "WiFi can't connect. Skipped this task once." >> $LOG_FILE
fi

# --- 4. 关闭 WiFi ---
echo "Turning off WiFi..." >> $LOG_FILE
lipc-set-prop com.lab126.wifid enable 0

echo "$(date): task done" >> $LOG_FILE
echo "------------------------------" >> $LOG_FILE