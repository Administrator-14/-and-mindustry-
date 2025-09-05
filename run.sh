#!/usr/bin/env bash
# 检查是否已安装 Java
if command -v java >/dev/null 2>&1; then
    echo "✅ Java 已安装：$(java -version 2>&1 | head -n 1)"
else
    echo " Java 未安装，正在安装...."
    pkg update -y
    pkg install openjdk-17 -y
fi
FACTORY_DIR="mindustry"
mkdir -p "$FACTORY_DIR"
JAR_FILE="$FACTORY_DIR/app.jar"

if [[ ! -f "$JAR_FILE" ]]; then
    echo "未检测到 $JAR_FILE，开始下载..."
    curl -L -o "$JAR_FILE" "https://gh.tinylake.top/https://github.com/Anuken/Mindustry/releases/download/v150.1/server-release.jar"
    [[ $? -ne 0 ]] && { echo "下载失败"; exit 1; }
    echo "下载完成：$JAR_FILE"
else
    echo "$JAR_FILE 已存在，跳过下载。"
fi
cd $FACTORY_DIR
if [[! -f "${mindustry}/config/mod/"]]; then
    echo "加载目录..."
    java -jar "app.jar" &
    JAVA_PID=$!
    sleep 3
    kill $JAVA_PID
fi
cd ..
path2="${FACTORY_DIR}/config"
mkdir -p "$path2/mods" "$path2/scripts"

plugin_jar="$path2/mods/ScriptAgent4MindustryExt-3.3.0.jar"
if [[ ! -f "$plugin_jar" ]]; then
    echo "正在下载插件"
    curl -L -o "$plugin_jar" "https://gh-proxy.com/https://github.com/way-zer/ScriptAgent4MindustryExt/releases/download/v3.3.0/ScriptAgent4MindustryExt-3.3.0.jar"
    [[ $? -ne 0 ]] && { echo "下载失败"; exit 1; }
fi

zip_path="$path2/scripts/ScriptAgent4MindustryExt-3.3.0-scripts.zip"
if [[ ! -f "$zip_path" ]]; then
    echo "正在下载脚本包"
    curl -L -o "$zip_path" "https://gh-proxy.com/https://github.com/way-zer/ScriptAgent4MindustryExt/releases/download/v3.3.0/ScriptAgent4MindustryExt-3.3.0-scripts.zip"
    [[ $? -ne 0 ]] && { echo "下载失败"; exit 1; }
fi

unzip -q -o "$zip_path" -d "$path2/scripts"
echo "服务器下载完毕,正在尝试启动"
cd $FACTORY_DIR
java -jar app.jar
