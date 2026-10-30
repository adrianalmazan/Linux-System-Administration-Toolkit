#!/usr/bin/env bash

service_management_menu() {
    local option service
    while true; do
        printf '\n=== SERVICE MANAGEMENT (systemd) ===\n'
        cat <<'MENU'
1. List active services
2. Check service status
3. Start a service
4. Stop a service
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                systemctl list-units --type=service --state=running --no-pager
                log_action "Listed active services"
                pause_module
                ;;
            2)
                read -r -p "Service name (e.g. ssh): " service
                if [[ "$service" =~ ^[A-Za-z0-9_.@-]+$ ]]; then
                    systemctl status "$service" --no-pager
                    log_action "Checked service $service"
                else
                    printf 'Invalid service name.\n'
                fi
                pause_module
                ;;
            3|4)
                require_root || { pause_module; continue; }
                read -r -p "Service name: " service
                if [[ ! "$service" =~ ^[A-Za-z0-9_.@-]+$ ]]; then
                    printf 'Invalid service name.\n'
                elif ! systemctl list-unit-files "${service}.service" --no-legend 2>/dev/null | grep -q .; then
                    printf 'Service unit not found. Check the service name.\n'
                elif [[ "$option" == "3" ]]; then
                    if confirm_action "Start service '$service'?"; then
                        if systemctl start "$service"; then
                            printf 'Start command completed.\n'
                            log_action "Started service $service"
                        else
                            printf 'Could not start service.\n'
                        fi
                    fi
                else
                    if confirm_action "Stop service '$service'?"; then
                        if systemctl stop "$service"; then
                            printf 'Stop command completed.\n'
                            log_action "Stopped service $service"
                        else
                            printf 'Could not stop service.\n'
                        fi
                    fi
                fi
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
