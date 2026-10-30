#!/usr/bin/env bash

network_management_menu() {
    local option host
    while true; do
        printf '\n=== NETWORK INFORMATION ===\n'
        cat <<'MENU'
1. Show network interfaces and IP addresses
2. Show listening ports and sockets
3. Test connectivity (ping)
4. Show DNS resolver configuration
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                ip -brief address
                log_action "Viewed network interfaces"
                pause_module
                ;;
            2)
                ss -tuln
                log_action "Viewed listening sockets"
                pause_module
                ;;
            3)
                read -r -p "Hostname or IP address: " host
                if [[ "$host" =~ ^[A-Za-z0-9.-]+$ ]]; then
                    ping -c 4 -W 2 -- "$host"
                    log_action "Tested connectivity to $host"
                else
                    printf 'Invalid hostname or IP format.\n'
                fi
                pause_module
                ;;
            4)
                if [[ -r /etc/resolv.conf ]]; then
                    cat /etc/resolv.conf
                else
                    printf 'Cannot read /etc/resolv.conf.\n'
                fi
                log_action "Viewed DNS resolver configuration"
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
