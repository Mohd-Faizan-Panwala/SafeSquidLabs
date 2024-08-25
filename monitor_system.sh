#!/bin/bash

# Function to display the top 10 applications by CPU and memory usage
top_apps() {
    echo "Top 10 Applications by CPU Usage:"
    ps aux --sort=-%cpu | awk 'NR<=11{print $0}' | less
    echo "Top 10 Applications by Memory Usage:"
    ps aux --sort=-%mem | awk 'NR<=11{print $0}' | less
}

# Function to monitor network
network_monitor() {
    echo "Number of Concurrent Connections:"
    netstat -an | grep ESTABLISHED | wc -l
    echo "Packet Drops:"
    netstat -i | grep -i 'drop' | awk '{print $3}'
    echo "Network Traffic (MB in/out):"
    ifstat -i eth0 1 1 | awk 'NR==3{print "IN:", $1, "OUT:", $2}'
}

# Function to display disk usage
disk_usage() {
    echo "Disk Usage by Mounted Partitions:"
    df -h
    echo "Partitions using more than 80% of space:"
    df -h | awk '$5 > 80 {print $0}'
}

# Function to show system load
system_load() {
    echo "Current Load Average:"
    uptime
    echo "CPU Usage Breakdown:"
    mpstat
}

# Function to display memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h
    echo "Swap Memory Usage:"
    swapon --show
}

# Function to monitor processes
process_monitor() {
    echo "Number of Active Processes:"
    ps aux | wc -l
    echo "Top 5 Processes by CPU Usage:"
    ps aux --sort=-%cpu | awk 'NR<=6{print $0}'
    echo "Top 5 Processes by Memory Usage:"
    ps aux --sort=-%mem | awk 'NR<=6{print $0}'
}

# Function to monitor services
service_monitor() {
    echo "Status of Essential Services:"
    for service in sshd nginx apache2 iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
}

# Command-line argument handling
case $1 in
    -cpu) top_apps ;;
    -network) network_monitor ;;
    -disk) disk_usage ;;
    -load) system_load ;;
    -memory) memory_usage ;;
    -process) process_monitor ;;
    -service) service_monitor ;;
    *) echo "Usage: $0 {-cpu|-network|-disk|-load|-memory|-process|-service}" ;;
esac
