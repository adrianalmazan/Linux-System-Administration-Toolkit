#!/usr/bin/env bash
# Linux System Administration Toolkit
# Educational administration toolkit for Linux systems.

set -o nounset
set -o pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$PROJECT_DIR/modules"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/linux-admin-toolkit"
LOG_FILE="$LOG_DIR/toolkit.log"

mkdir -p "$LOG_DIR"
chmod 700 "$LOG_DIR"

# shellcheck source=modules/common.sh
source "$MODULE_DIR/common.sh"
source "$MODULE_DIR/system_monitoring.sh"
source "$MODULE_DIR/user_management.sh"
source "$MODULE_DIR/network_management.sh"
source "$MODULE_DIR/service_management.sh"
source "$MODULE_DIR/file_management.sh"
source "$MODULE_DIR/security_logs.sh"

show_header() {
    clear 2>/dev/null || true
    printf '%s\n' "=================================================="
    printf '%s\n' "       LINUX SYSTEM ADMINISTRATION TOOLKIT"
    printf '%s\n' "=================================================="
    printf ' Host: %s | User: %s\n' "$(hostname)" "$USER"
    printf ' Date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')"
    printf '%s\n\n' "--------------------------------------------------"
}

show_menu() {
    show_header
    cat <<'MENU'
  1. System monitoring
  2. User and group management
  3. Network information
  4. Service management
  5. File and permission management
  6. Security and system logs

  0. Exit
MENU
    printf '\n'
}

pause() {
    printf '\nPress ENTER to continue...'
    read -r _
}

main() {
    local option
    log_action "Toolkit started"

    while true; do
        show_menu
        read -r -p "Select an option: " option

        case "$option" in
            1) system_monitoring_menu ;;
            2) user_management_menu ;;
            3) network_management_menu ;;
            4) service_management_menu ;;
            5) file_management_menu ;;
            6) security_logs_menu ;;
            0)
                log_action "Toolkit closed"
                printf '\nGoodbye.\n'
                exit 0
                ;;
            *)
                printf '\nInvalid option.\n'
                pause
                ;;
        esac
    done
}

main "$@"
