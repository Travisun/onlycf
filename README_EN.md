# OnlyCF - Cloudflare IP Firewall Management Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

OnlyCF is a script tool for managing server firewalls, specifically designed to ensure that only traffic from Cloudflare can access specified ports. It supports both iptables and ufw firewalls and provides a bilingual interface in Chinese and English.

Author: Travis Tang https://investravis.com

## Features

- 🌍 Bilingual interface (Chinese/English)
- 🔒 Automatic retrieval and update of Cloudflare IP lists
- 🛡️ Support for iptables and ufw firewalls
- ⏰ Scheduled automatic updates
- 🔄 Multi-port configuration support
- 💾 Automatic configuration backup
- 📝 Detailed operation logs

## How It Works

1. Fetches the latest IP address lists from official Cloudflare sources:
   - IPv4: https://www.cloudflare.com/ips-v4
   - IPv6: https://www.cloudflare.com/ips-v6

2. Configures firewall rules:
   - Blocks all access to specified ports
   - Allows access only from Cloudflare IPs
   - Supports both IPv4 and IPv6

## System Requirements

- Linux system
- Root privileges
- curl
- iptables or ufw
- cron (for automatic updates)

## Installation and Usage

### Quick Start

1. Download and install:
```bash
wget https://raw.githubusercontent.com/Travisun/onlycf/main/run.sh -O onlycf.sh && chmod +x onlycf.sh && sudo ./onlycf.sh install
```

After installation, the original installer package will be automatically cleaned up.

### Command Reference
```bash
sudo onlycf [command] [options]

Available commands:
- `install`: Install OnlyCF to the system
- `update`: Update Cloudflare IPs and apply rules
- `config`: Configure OnlyCF settings
- `uninstall`: Uninstall OnlyCF

Options:
- `-p, --ports`: Specify ports to protect, comma-separated (default: 80,443)
- `-f, --firewall`: Specify firewall type (iptables or ufw, default: iptables)
- `-h, --help`: Show help information
```

### Usage Examples

1. Update Cloudflare IP rules:
```bash
sudo onlycf update
```

2. Modify configuration:
```bash
sudo onlycf config
```

3. Check current status:
```bash
sudo onlycf status
```

## Automatic Updates

During installation, you can choose the automatic update frequency:
- Daily (recommended)
- Weekly
- Monthly
- No automatic updates

## File Locations

- Installation directory: `/etc/onlyCF/`
- Main program: `/etc/onlyCF/onlycf.sh`
- Configuration file: `/etc/onlyCF/config`
- Language settings: `/etc/onlyCF/language`
- Cron job: `/etc/cron.d/onlycf`
- IP list cache: `/etc/onlyCF/temp/`

## Important Notes

1. Requires root privileges
2. Ensure curl is installed
3. UFW mode will reset existing firewall rules, use with caution
4. Recommended to backup existing firewall rules before first use:
```bash
# For iptables
sudo iptables-save > iptables-backup.rules
sudo ip6tables-save > ip6tables-backup.rules

# For ufw
sudo cp -r /etc/ufw /etc/ufw.backup
```

## Uninstallation

To uninstall, run:
```bash
sudo ./onlycf.sh uninstall
```

During uninstallation:
- Automatically backs up existing configuration to `/tmp/onlycf_backup_timestamp/`
- Clears firewall rules
- Removes all related files

## Troubleshooting

1. If website is inaccessible:
   - Check if port configuration is correct
   - Verify firewall rules are properly applied:
     ```bash
     # iptables
     sudo iptables -L -n | grep CLOUDFLARE
     
     # ufw
     sudo ufw status
     ```
   - Verify Cloudflare IP list is updated successfully

2. If updates fail:
   - Check network connection
   - Confirm sufficient disk space
   - Check for permission issues
   - Review logs:
     ```bash
     sudo tail -f /var/log/syslog | grep onlycf
     ```

3. To restore backups:
   - Configuration backups are in `/etc/onlyCF/config.bak`
   - Complete uninstall backups are in `/tmp/onlycf_backup_*`

## Security Recommendations

1. Regularly check firewall rules
2. Keep automatic updates enabled
3. Monitor access logs for anomalies
4. Backup configuration periodically

## Contributing

Issues and Pull Requests are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Changelog

### v1.0.0 (2024-03)
- Initial release
- Support for iptables and ufw
- Bilingual interface
- Automatic update functionality

## Contact

- Author: Travis Tang
- Website: https://investravis.com
- GitHub: https://github.com/Travisun

## Acknowledgments

Thanks to everyone who has provided suggestions and help for this project! 