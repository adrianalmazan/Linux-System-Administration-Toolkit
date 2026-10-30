#!/usr/bin/env bash

system_monitoring_menu() {
    local option
    while true; do
        printf '\n=== SYSTEM MONITORING ===\n'
        cat <<'MENU'
1. CPU and system load
2. Memory usage
3. Disk usage
4. System uptime
5. Top processes by CPU
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                print_section "CPU and load"
                uptime
                if command -v mpstat >/dev/null 2>&1; then
                    mpstat 1 1
                else
                    printf 'CPU statistics utility (mpstat) is not installed.\n'
                    printf 'Install with: sudo apt install sysstat\n'
                fi
                log_action "Viewed CPU and load information"
                pause_module
                ;;
            2)
                print_section "Memory usage"
                free -h
                log_action "Viewed memory information"
                pause_module
                ;;
            3)
                print_section "Disk usage"
                df -hT
                log_action "Viewed disk usage"
                pause_module
                ;;
            4)
                print_section "System uptime"
                uptime -p
                printf 'Boot time: '
                who -b
                log_action "Viewed system uptime"
                pause_module
                ;;
            5)
                print_section "Top processes by CPU"
                ps -eo pid,ppid,user,%cpu,%mem,comm --sort=-%cpu | head -n 11
                log_action "Viewed top processes"
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
