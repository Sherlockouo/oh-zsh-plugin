#!/bin/bash

# 定义插件安装目录
plugin_dir="$ZSH/plugins/"

# 检测 requirements.txt 文件是否存在
if [ ! -f "requirements.txt" ]; then
	echo "requirements.txt 文件不存在，请创建该文件并添加插件链接"
	exit 1
fi

# 并发克隆插件函数
clone_plugin() {
	local plugin_url=$1
	local plugin_name=$(basename "$plugin_url" | cut -d. -f1)
	local target_dir="$plugin_dir/$plugin_name"

	# 检查目标目录是否已存在重名插件
	if [ -d "$target_dir" ]; then
		echo "插件 $plugin_name 已存在，跳过克隆"
		return
	fi

	# 克隆插件到插件目录
	git clone "$plugin_url" "$target_dir"

	# 输出克隆成功信息
	echo "插件 $plugin_name 克隆成功"
}

installed_plugins=() # 存储已安装的插件名称

# 读取 requirements.txt 文件的每一行，并使用并发克隆插件
while IFS= read -r plugin_url; do
	clone_plugin "$plugin_url" &
	plugin_name=$(basename "$plugin_url" | cut -d. -f1)
	installed_plugins+=("$plugin_name") # 将已安装的插件名称添加到数组中
done <requirements.txt

# 等待所有克隆任务完成
wait

# 输出已安装的插件名称，用空格隔开
echo "已安装的插件: ${installed_plugins[*]}"

echo "所有插件克隆完成"
