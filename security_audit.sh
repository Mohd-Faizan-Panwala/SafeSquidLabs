#!/bin/bash

# Function to audit users and groups
user_group_audit() {
    echo "List of Users and Groups:"
    cat /etc/passwd
    cat /etc/group
    echo "Users with UID 0 (root privileges):"
    awk -F: '$3 == 0 {print $1}' /etc/passwd
    echo "Users without passwords or with weak passwords:"
    awk -F: '($2 == "" || $2 == "*") {print $1}' /etc/shadow
}

# Function to check file and directory permissions
file_permissions() {
    echo "Files and Directories with World-Writable Permissions:"
    find / -type f -perm -0002 -exec ls -ld {} \;
    echo "Checking .ssh Directories Permissions:"
    find / -type d -name '.ssh' -exec ls -ld {} \;
    echo "Files with SUID or SGID Bits Set:"
    find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ld {} \;
}

# Function to audit services
service_audit() {
    echo "Running Services:"
    systemctl list-units --type=service
    echo "Critical Services Status:"
    for service in sshd iptables; do
        systemctl status $service | grep "Active:"
    done
}

# Function to check firewall and network security
firewall_network_security() {
    echo "Firewall Status:"
    ufw status verbose || iptables -L -v -n
    echo "Open Ports and Associated Services:"
    netstat -tuln
    echo "Checking IP Forwarding and Network Configurations:"
    sysctl net.ipv4.ip_forward
    sysctl net.ipv6.conf.all.forwarding
}

# Function to check IP and network configurations
ip_network_checks() {
    echo "Public vs. Private IP Checks:"
    ip -br a
    echo "Summary of IP Addresses:"
    # Implement logic for public/private checks
}

# Function to check for security updates and patches
security_updates() {
    echo "Checking for Available Security Updates:"
    apt list --upgradable | grep security
    echo "Ensuring Automatic Security Updates are Enabled:"
    dpkg-reconfigure --priority=low unattended-upgrades
}

# Function to monitor logs for suspicious entries
log_monitoring() {
    echo "Recent Suspicious Log Entries:"
    grep 'Failed password' /var/log/auth.log
}

# Function to implement server hardening
server_hardening() {
    echo "Implementing SSH Key-Based Authentication:"
    sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config
    echo "Disabling IPv6 (if required):"
    # Commands to disable IPv6
    echo "Securing GRUB Bootloader:"
    grub-mkpasswd-pbkdf2
    # Other hardening steps
}

# Function to run custom security checks
custom_checks() {
    echo "Running Custom Security Checks:"
    # Implement custom checks based on organizational policies
}

# Command-line argument handling
case $1 in
    -user) user_group_audit ;;
    -permissions) file_permissions ;;
    -services) service_audit ;;
    -firewall) firewall_network_security ;;
    -ip) ip_network_checks ;;
    -updates) security_updates ;;
    -log) log_monitoring ;;
    -hardening) server_hardening ;;
    -custom) custom_checks ;;
    *) echo "Usage: $0 {-user|-permissions|-services|-firewall|-ip|-updates|-log|-hardening|-custom}" ;;
esac
