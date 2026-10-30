#!/usr/bin/env bash

security_logs_menu() {
    local option
    while true; do
        printf '\n=== SECURITY AND SYSTEM LOGS ===\n'
        cat <<'MENU'
1. Show recent system journal entries
2. Show recent authentication log entries
3. Check for world-writable files in a directory
4. Show toolkit activity log
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                if command -v journalctl >/dev/null 2>&1; then
                    journalctl -n 30 --no-pager
                else
                    printf 'journalctl is not available on this system.\n'
                fi
                log_action "Viewed recent journal entries"
                pause_module
                ;;
            2)
                if [[ -r /var/log/auth.log ]]; then
                    tail -n 30 /var/log/auth.log
                elif [[ -r /var/log/secure ]]; then
                    tail -n 30 /var/log/secure
                else
                    printf 'Authentication log file is unavailable or unreadable.\n'
                    printf 'On systemd systems, try journalctl -u ssh.\n'
                fi
                log_action "Viewed authentication log entries"
                pause_module
                ;;
            3)
                local directory
                read -r -p "Directory to inspect: " directory
                if [[ -d "$directory" ]]; then
                    printf 'World-writable files and directories under %s:\n' "$directory"
                    find "$directory" -xdev -perm -0002 -print 2>/dev/null | head -n 100
                    log_action "Checked world-writable paths under $directory"
                else
                    printf 'Directory does not exist.\n'
                fi
                pause_module
                ;;
            4)
                if [[ -r "$LOG_FILE" ]]; then
                    tail -n 50 "$LOG_FILE"
                else
                    printf 'No toolkit activity has been logged yet.\n'
                fi
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
