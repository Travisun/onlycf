# OnlyCF - Cloudflare IP 防火墙管理工具

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

OnlyCF 是一个用于管理服务器防火墙的脚本工具，专门用于确保只允许来自 Cloudflare 的流量访问指定端口。支持 iptables 和 ufw 防火墙，并提供中英文双语界面。

作者：甜辣酱(Travis Tang) https://investravis.com

## 功能特点

- 🌍 支持中英文双语界面
- 🔒 自动获取并更新 Cloudflare IP 列表
- 🛡️ 支持 iptables 和 ufw 防火墙
- ⏰ 支持自动定期更新
- 🔄 支持多个端口配置
- 💾 自动配置备份
- 📝 详细的操作日志

## 工作原理

1. 从 Cloudflare 官方源获取最新的 IP 地址列表：
   - IPv4: https://www.cloudflare.com/ips-v4
   - IPv6: https://www.cloudflare.com/ips-v6

2. 配置防火墙规则：
   - 阻止所有来源对指定端口的访问
   - 只允许来自 Cloudflare IP 的访问
   - 支持 IPv4 和 IPv6

## 系统要求

- Linux 系统
- root 权限
- curl
- iptables 或 ufw
- cron（用于自动更新）

## 安装使用

### 快速开始

1. 下载脚本：
```bash
wget https://raw.githubusercontent.com/Travisun/onlycf/main/run.sh -O onlycf.sh
chmod +x onlycf.sh
```
### 命令说明
```bash
sudo ./onlycf.sh [命令] [选项]

可用命令：
- `install`: 安装 OnlyCF 到系统
- `update`: 更新 Cloudflare IP 并应用规则
- `config`: 配置 OnlyCF 设置
- `uninstall`: 卸载 OnlyCF

选项：
- `-p, --ports`: 指定要保护的端口，用逗号分隔（默认：80,443）
- `-f, --firewall`: 指定防火墙类型（iptables 或 ufw，默认：iptables）
- `-h, --help`: 显示帮助信息
```

### 使用示例

1. 安装并保护 80、443 端口：
```bash
sudo ./onlycf.sh install
```

2. 安装并保护自定义端口：
```bash
sudo ./onlycf.sh install -p 80,443,8080
```

3. 使用 UFW 防火墙：
```bash
sudo ./onlycf.sh install -f ufw
```

4. 手动更新 IP 规则：
```bash
sudo ./onlycf.sh update
```

5. 修改配置：
```bash
sudo ./onlycf.sh config
```

## 自动更新

安装时可以选择自动更新频率：
- 每天更新（建议）
- 每周更新
- 每月更新
- 不自动更新

## 文件位置

- 安装目录：`/etc/onlyCF/`
- 主程序：`/etc/onlyCF/onlycf.sh`
- 配置文件：`/etc/onlyCF/config`
- 语言配置：`/etc/onlyCF/language`
- 定时任务：`/etc/cron.d/onlycf`
- IP列表缓存：`/etc/onlyCF/temp/`

## 注意事项

1. 需要 root 权限运行
2. 确保服务器已安装 curl
3. UFW 模式会重置现有防火墙规则，请谨慎使用
4. 建议首次使用前备份现有防火墙规则：
```bash
# 对于 iptables
sudo iptables-save > iptables-backup.rules
sudo ip6tables-save > ip6tables-backup.rules

# 对于 ufw
sudo cp -r /etc/ufw /etc/ufw.backup
```

## 卸载

如需卸载，运行：
```bash
sudo ./onlycf.sh uninstall
```

卸载时会：
- 自动备份现有配置到 `/tmp/onlycf_backup_时间戳/`
- 清除防火墙规则
- 删除所有相关文件

## 故障排除

1. 如果无法访问网站：
   - 检查端口配置是否正确
   - 确认防火墙规则是否正确应用：
     ```bash
     # iptables
     sudo iptables -L -n | grep CLOUDFLARE
     
     # ufw
     sudo ufw status
     ```
   - 验证 Cloudflare IP 列表是否成功更新

2. 如果更新失败：
   - 检查网络连接
   - 确认是否有足够的磁盘空间
   - 查看是否有权限问题
   - 检查日志：
     ```bash
     sudo tail -f /var/log/syslog | grep onlycf
     ```

3. 如果需要恢复备份：
   - 配置文件备份位于 `/etc/onlyCF/config.bak`
   - 卸载时的完整备份位于 `/tmp/onlycf_backup_*`

## 安全建议

1. 定期检查防火墙规则
2. 保持自动更新开启
3. 监控异常访问日志
4. 定期备份配置

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 更新日志

### v1.0.0 (2024-03)
- 初始发布
- 支持 iptables 和 ufw
- 中英文双语界面
- 自动更新功能

## 联系方式

- 作者：甜辣酱(Travis Tang)
- 网站：https://investravis.com
- GitHub：https://github.com/Travisun

## 致谢

感谢所有为此项目提供建议和帮助的朋友们！
