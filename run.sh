#!/bin/bash

# OnlyCF - Cloudflare IP 防火墙管理工具
# 作者：甜辣酱(Travis Tang) https://investravis.com
# 
# MIT License
# 
# Copyright (c) 2024 Travis Tang
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# 配置变量
INSTALL_DIR="/etc/onlyCF"
SCRIPT_PATH="$INSTALL_DIR/onlycf.sh"
PORTS="80,443"
FIREWALL="iptables"
IPV4_URL="https://www.cloudflare.com/ips-v4"
IPV6_URL="https://www.cloudflare.com/ips-v6"
TEMP_DIR="$INSTALL_DIR/temp"
CRON_FILE="/etc/cron.d/onlycf"

# 语言配置
LANG_FILE="$INSTALL_DIR/language"
CURRENT_LANG="en"  # 默认语言为英语

# 翻译函数
t() {
    local key="$1"
    case "$CURRENT_LANG" in
        "zh")
            case "$key" in
                "select_language")
                    echo "请选择语言 / Please select language:"
                    echo "1) English"
                    echo "2) 中文"
                    ;;
                "invalid_choice")
                    echo "无效的选择"
                    ;;
                "need_root")
                    echo "需要root权限，请使用sudo运行此命令"
                    ;;
                "select_update_frequency")
                    echo "您想多久更新一次Cloudflare IP列表？"
                    ;;
                "daily")
                    echo "每天"
                    ;;
                "weekly")
                    echo "每周"
                    ;;
                "monthly")
                    echo "每月"
                    ;;
                "no_auto_update")
                    echo "不设置自动更新"
                    ;;
                "auto_update_not_set")
                    echo "未设置自动更新"
                    ;;
                "install_success")
                    echo "OnlyCF 已成功安装到 $INSTALL_DIR"
                    ;;
                "start_initial_config")
                    echo "现在开始首次配置..."
                    ;;
                "select_firewall")
                    echo "请选择防火墙类型："
                    ;;
                "enter_ports")
                    echo "请输入要保护的端口（用逗号分隔，直接回车使用默认值80,443）: "
                    ;;
                "config_saved")
                    echo "配置已保存。是否立即应用新设置？"
                    ;;
                "confirm_continue")
                    echo "是否继续？ [y/N]: "
                    ;;
                "uninstall_warning")
                    echo "警告：这将删除OnlyCF的所有文件和配置"
                    ;;
                "uninstall_success")
                    echo "OnlyCF 已成功卸载"
                    ;;
                "downloading")
                    echo "正在下载Cloudflare IP列表..."
                    ;;
                "configuring")
                    echo "正在配置防火墙规则..."
                    ;;
                "unsupported_firewall")
                    echo "不支持的防火墙类型: $FIREWALL"
                    ;;
                "config_complete")
                    echo "防火墙规则配置完成！"
                    ;;
                "config_title")
                    echo "配置"
                    ;;
                "select_choice")
                    echo "请选择"
                    ;;
                "invalid_choice_default")
                    echo "无效的选择，使用默认值"
                    ;;
                "invalid_ports")
                    echo "无效的端口格式"
                    ;;
                "already_installed")
                    echo "OnlyCF 已经安装"
                    ;;
                "reinstall_confirm")
                    echo "是否重新安装？[y/N]: "
                    ;;
                "config_backup")
                    echo "配置已备份到"
                    ;;
                "config_not_found")
                    echo "未找到配置文件"
                    ;;
                "download_failed")
                    echo "下载 Cloudflare IP 列表失败"
                    ;;
                "invalid_ip_lists")
                    echo "无效的 IP 列表"
                    ;;
                "install_complete_guide")
                    echo "安装完成！以下是使用指南："
                    ;;
                "usage_command_prefix")
                    echo "使用命令格式："
                    ;;
                "available_commands")
                    echo "可用命令"
                    ;;
                "cmd_update_desc")
                    echo "更新 Cloudflare IP 列表并应用防火墙规则"
                    ;;
                "cmd_config_desc")
                    echo "修改配置设置"
                    ;;
                "cmd_uninstall_desc")
                    echo "卸载 OnlyCF"
                    ;;
                "example_usage")
                    echo "使用示例"
                    ;;
                "example_update_desc")
                    echo "更新 Cloudflare IPs 并应用规则"
                    ;;
                "example_config_desc")
                    echo "修改配置设置"
                    ;;
                "install_location")
                    echo "安装位置"
                    ;;
                "config_file_location")
                    echo "配置文件位置"
                    ;;
                "next_step_prompt")
                    echo "现在开始进行初始配置..."
                    ;;
                "installer_cleaned")
                    echo "安装包已清理"
                    ;;
                "select_language_setting")
                    echo "请选择要修改的设置："
                    ;;
                "language_setting")
                    echo "语言设置"
                    ;;
                "firewall_setting")
                    echo "防火墙设置"
                    ;;
                "ports_setting")
                    echo "端口设置"
                    ;;
                *)
                    echo "[$key]"  # 如果没有找到翻译，返回键名
                    ;;
            esac
            ;;
        "en")
            case "$key" in
                "select_language")
                    echo "Please select language / 请选择语言:"
                    echo "1) English"
                    echo "2) 中文"
                    ;;
                "invalid_choice")
                    echo "Invalid choice"
                    ;;
                "need_root")
                    echo "Root privileges required, please run with sudo"
                    ;;
                "select_update_frequency")
                    echo "How often do you want to update Cloudflare IP list?"
                    ;;
                "daily")
                    echo "Daily"
                    ;;
                "weekly")
                    echo "Weekly"
                    ;;
                "monthly")
                    echo "Monthly"
                    ;;
                "no_auto_update")
                    echo "No automatic updates"
                    ;;
                "auto_update_not_set")
                    echo "Automatic update not set"
                    ;;
                "install_success")
                    echo "OnlyCF has been successfully installed to $INSTALL_DIR"
                    ;;
                "start_initial_config")
                    echo "Starting initial configuration..."
                    ;;
                "select_firewall")
                    echo "Please select firewall type:"
                    ;;
                "enter_ports")
                    echo "Enter ports to protect (comma-separated, press Enter for default 80,443): "
                    ;;
                "config_saved")
                    echo "Configuration saved. Apply new settings now?"
                    ;;
                "confirm_continue")
                    echo "Continue? [y/N]: "
                    ;;
                "uninstall_warning")
                    echo "Warning: This will remove all OnlyCF files and configurations"
                    ;;
                "uninstall_success")
                    echo "OnlyCF has been successfully uninstalled"
                    ;;
                "downloading")
                    echo "Downloading Cloudflare IP lists..."
                    ;;
                "configuring")
                    echo "Configuring firewall rules..."
                    ;;
                "unsupported_firewall")
                    echo "Unsupported firewall type: $FIREWALL"
                    ;;
                "config_complete")
                    echo "Firewall rules configuration completed!"
                    ;;
                "config_title")
                    echo "Configuration"
                    ;;
                "select_choice")
                    echo "Select"
                    ;;
                "invalid_choice_default")
                    echo "Invalid choice, using default value"
                    ;;
                "invalid_ports")
                    echo "Invalid port format"
                    ;;
                "already_installed")
                    echo "OnlyCF is already installed"
                    ;;
                "reinstall_confirm")
                    echo "Do you want to reinstall? [y/N]: "
                    ;;
                "config_backup")
                    echo "Configuration backed up to"
                    ;;
                "config_not_found")
                    echo "Configuration file not found"
                    ;;
                "download_failed")
                    echo "Failed to download Cloudflare IP lists"
                    ;;
                "invalid_ip_lists")
                    echo "Invalid IP lists"
                    ;;
                "install_complete_guide")
                    echo "Installation completed! Here's your usage guide:"
                    ;;
                "usage_command_prefix")
                    echo "Command format:"
                    ;;
                "available_commands")
                    echo "Available commands"
                    ;;
                "cmd_update_desc")
                    echo "Update Cloudflare IP lists and apply firewall rules"
                    ;;
                "cmd_config_desc")
                    echo "Modify configuration settings"
                    ;;
                "cmd_uninstall_desc")
                    echo "Uninstall OnlyCF"
                    ;;
                "example_usage")
                    echo "Usage examples"
                    ;;
                "example_update_desc")
                    echo "Update Cloudflare IPs and apply rules"
                    ;;
                "example_config_desc")
                    echo "Modify configuration settings"
                    ;;
                "install_location")
                    echo "Installation location"
                    ;;
                "config_file_location")
                    echo "Configuration file location"
                    ;;
                "next_step_prompt")
                    echo "Starting initial configuration..."
                    ;;
                "installer_cleaned")
                    echo "Installer package has been cleaned up"
                    ;;
                "select_language_setting")
                    echo "Please select setting to modify:"
                    ;;
                "language_setting")
                    echo "Language Settings"
                    ;;
                "firewall_setting")
                    echo "Firewall Settings"
                    ;;
                "ports_setting")
                    echo "Ports Settings"
                    ;;
                *)
                    echo "[$key]"
                    ;;
            esac
            ;;
    esac
}

# 语言选择函数
select_language() {
    echo "$(t select_language)"
    read -p "Choice/选择 [1-2]: " lang_choice
    case $lang_choice in
        1)
            CURRENT_LANG="en"
            ;;
        2)
            CURRENT_LANG="zh"
            ;;
        *)
            CURRENT_LANG="en"  # 默认使用英语
            echo "$(t invalid_choice)"
            ;;
    esac
    
    # 保存语言选择
    echo "CURRENT_LANG=\"$CURRENT_LANG\"" > "$LANG_FILE"
}

# 加载已保存的语言设置
load_language() {
    if [ -f "$LANG_FILE" ]; then
        source "$LANG_FILE"
    else
        select_language
    fi
}

# 帮助信息
show_help() {
    echo "用法: $0 [命令] [选项]"
    echo "命令:"
    echo "  install    安装OnlyCF到系统"
    echo "  update    更新Cloudflare IP并应用规则"
    echo "  config    配置OnlyCF设置"
    echo "  uninstall 卸载OnlyCF"
    echo
    echo "选项:"
    echo "  -p, --ports     指定要保护的端口，用逗号分隔 (默认: 80,443)"
    echo "  -f, --firewall  指定防火墙类型 (iptables 或 ufw, 默认: iptables)"
    echo "  -h, --help      显示此帮助信息"
    exit 0
}

# 检查是否为root用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "$(t need_root)"
        exit 1
    fi
}

# 安装脚本
install_script() {
    check_root
    
    # 在安装开始时先选择语言
    select_language
    
    # 检查是否已安装
    if [ -d "$INSTALL_DIR" ]; then
        echo "$(t already_installed)"
        read -p "$(t reinstall_confirm)" confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            exit 1
        fi
        # 备份旧配置
        if [ -f "$INSTALL_DIR/config" ]; then
            cp "$INSTALL_DIR/config" "$INSTALL_DIR/config.bak"
        fi
    fi
    
    # 创建安装目录
    mkdir -p "$INSTALL_DIR" "$TEMP_DIR"
    
    # 复制脚本到安装目录
    cp "$0" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
    
    # 创建软链接到 /usr/local/bin
    ln -sf "$SCRIPT_PATH" "/usr/local/bin/onlycf"
    
    # 创建配置文件，添加语言设置
    cat > "$INSTALL_DIR/config" <<EOF
PORTS="80,443"
FIREWALL="$FIREWALL"
CURRENT_LANG="$CURRENT_LANG"
EOF
    
    # 设置定时任务
    echo "$(t select_update_frequency)"
    echo "1) $(t daily)"
    echo "2) $(t weekly)"
    echo "3) $(t monthly)"
    echo "4) $(t no_auto_update)"
    read -p "$(t select_choice) [1-4]: " cron_choice
    
    case $cron_choice in
        1)
            echo "0 0 * * * root $SCRIPT_PATH update" > "$CRON_FILE"
            chmod 644 "$CRON_FILE"
            ;;
        2)
            echo "0 0 * * 0 root $SCRIPT_PATH update" > "$CRON_FILE"
            chmod 644 "$CRON_FILE"
            ;;
        3)
            echo "0 0 1 * * root $SCRIPT_PATH update" > "$CRON_FILE"
            chmod 644 "$CRON_FILE"
            ;;
        4)
            echo "$(t auto_update_not_set)"
            rm -f "$CRON_FILE"
            ;;
        *)
            echo "$(t invalid_choice)"
            rm -f "$CRON_FILE"
            ;;
    esac
    
    # 获取当前脚本的路径
    CURRENT_SCRIPT=$(readlink -f "$0")
    
    echo "$(t install_success)"
    echo "================================================================"
    echo "$(t install_complete_guide)"
    echo
    echo "1. $(t usage_command_prefix) onlycf [command]"
    echo
    echo "$(t available_commands):"
    echo "   update    - $(t cmd_update_desc)"
    echo "   config    - $(t cmd_config_desc)"
    echo "   uninstall - $(t cmd_uninstall_desc)"
    echo
    echo "$(t example_usage):"
    echo "   sudo onlycf update    - $(t example_update_desc)"
    echo "   sudo onlycf config    - $(t example_config_desc)"
    echo
    echo "$(t install_location): $INSTALL_DIR"
    echo "$(t config_file_location): $INSTALL_DIR/config"
    echo
    echo "$(t next_step_prompt)"
    echo "================================================================"
    
    # 如果是从下载的安装包运行的，删除安装包
    if [ "$CURRENT_SCRIPT" != "$SCRIPT_PATH" ]; then
        rm -f "$CURRENT_SCRIPT"
        echo "$(t installer_cleaned)"
    fi
    
    echo "$(t start_initial_config)"
    configure_settings
}

# 配置设置
configure_settings() {
    echo "=== OnlyCF $(t config_title) ==="
    
    # 添加语言设置选项
    echo "$(t select_language_setting)"
    echo "1) $(t language_setting)"
    echo "2) $(t firewall_setting)"
    echo "3) $(t ports_setting)"
    read -p "$(t select_choice) [1-3]: " setting_choice
    
    case $setting_choice in
        1)
            select_language
            ;;
        2)
            configure_firewall
            ;;
        3)
            configure_ports
            ;;
        *)
            echo "$(t invalid_choice)"
            return 1
            ;;
    esac
    
    # 保存所有配置
    cat > "$INSTALL_DIR/config" <<EOF
PORTS="$PORTS"
FIREWALL="$FIREWALL"
CURRENT_LANG="$CURRENT_LANG"
EOF
    
    echo "$(t config_saved)"
    read -p "$(t confirm_continue)" confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        update_rules
    fi
}

# 卸载脚本
uninstall_script() {
    check_root
    
    echo "$(t uninstall_warning)"
    read -p "$(t confirm_continue)" confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        # 删除软链接
        rm -f "/usr/local/bin/onlycf"
        
        # 备份配置
        if [ -d "$INSTALL_DIR" ]; then
            backup_dir="/tmp/onlycf_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$backup_dir"
            cp -r "$INSTALL_DIR"/* "$backup_dir/"
            echo "$(t config_backup) $backup_dir"
        fi
        
        # 清除防火墙规则
        case "$FIREWALL" in
            "iptables")
                iptables-save | grep -v "CLOUDFLARE" | iptables-restore
                ip6tables-save | grep -v "CLOUDFLARE" | ip6tables-restore
                ;;
            "ufw")
                ufw --force reset
                ufw default deny incoming
                ufw default allow outgoing
                ufw --force enable
                ;;
        esac
        
        # 删除文件
        rm -rf "$INSTALL_DIR"
        rm -f "$CRON_FILE"
        echo "$(t uninstall_success)"
    fi
}

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 下载Cloudflare IP列表
download_ip_lists() {
    curl -s "$IPV4_URL" > "$TEMP_DIR/ipv4.txt"
    curl -s "$IPV6_URL" > "$TEMP_DIR/ipv6.txt"
}

# 使用iptables配置防火墙规则
configure_iptables() {
    # 清除现有的Cloudflare规则
    iptables-save | grep -v "CLOUDFLARE" | iptables-restore
    ip6tables-save | grep -v "CLOUDFLARE" | ip6tables-restore

    # 为每个端口添加规则
    IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
    for port in "${PORT_ARRAY[@]}"; do
        # 默认禁止访问这些端口
        iptables -A INPUT -p tcp --dport "$port" -j DROP
        ip6tables -A INPUT -p tcp --dport "$port" -j DROP

        # 允许Cloudflare IPv4
        while read -r ip; do
            [[ -z "$ip" ]] && continue
            iptables -I INPUT -p tcp --dport "$port" -s "$ip" -j ACCEPT -m comment --comment "CLOUDFLARE"
        done < "$TEMP_DIR/ipv4.txt"

        # 允许Cloudflare IPv6
        while read -r ip; do
            [[ -z "$ip" ]] && continue
            ip6tables -I INPUT -p tcp --dport "$port" -s "$ip" -j ACCEPT -m comment --comment "CLOUDFLARE"
        done < "$TEMP_DIR/ipv6.txt"
    done
}

# 使用ufw配置防火墙规则
configure_ufw() {
    # 重置UFW规则
    ufw --force reset

    # 默认拒绝入站连接
    ufw default deny incoming
    ufw default allow outgoing

    # 为每个端口添加规则
    IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
    for port in "${PORT_ARRAY[@]}"; do
        # 允许Cloudflare IPv4
        while read -r ip; do
            [[ -z "$ip" ]] && continue
            ufw allow from "$ip" to any port "$port" proto tcp comment 'Cloudflare IPv4'
        done < "$TEMP_DIR/ipv4.txt"

        # 允许Cloudflare IPv6
        while read -r ip; do
            [[ -z "$ip" ]] && continue
            ufw allow from "$ip" to any port "$port" proto tcp comment 'Cloudflare IPv6'
        done < "$TEMP_DIR/ipv6.txt"
    done

    # 启用UFW
    ufw --force enable
}

# 更新规则
update_rules() {
    check_root
    
    # 加载配置
    if [ -f "$INSTALL_DIR/config" ]; then
        source "$INSTALL_DIR/config"
    else
        echo "$(t config_not_found)"
        exit 1
    fi
    
    # 下载IP列表
    echo "$(t downloading)"
    if ! download_ip_lists; then
        echo "$(t download_failed)"
        exit 1
    fi
    
    # 验证下载的文件
    if [ ! -s "$TEMP_DIR/ipv4.txt" ] || [ ! -s "$TEMP_DIR/ipv6.txt" ]; then
        echo "$(t invalid_ip_lists)"
        exit 1
    fi
    
    # 配置防火墙规则
    echo "$(t configuring)"
    case "$FIREWALL" in
        "iptables")
            configure_iptables
            ;;
        "ufw")
            configure_ufw
            ;;
        *)
            echo "$(t unsupported_firewall) $FIREWALL"
            exit 1
            ;;
    esac
    
    echo "$(t config_complete)"
}

# 修改加载配置的函数
load_config() {
    if [ -f "$INSTALL_DIR/config" ]; then
        source "$INSTALL_DIR/config"
    else
        # 如果配置文件不存在，使用默认值
        PORTS="80,443"
        FIREWALL="iptables"
        CURRENT_LANG="en"
    fi
}

# 主程序
main() {
    # 加载配置（包括语言设置）
    if [ "$1" != "install" ]; then
        load_config
    fi
    
    case "$1" in
        "install")
            install_script
            ;;
        "update")
            update_rules
            ;;
        "config")
            configure_settings
            ;;
        "uninstall")
            uninstall_script
            ;;
        *)
            show_help
            ;;
    esac
}

# 运行主程序
main "$@"
