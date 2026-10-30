#!/usr/bin/env bash

# Shared helper functions used by all modules.

log_action() {
    local message="$1"
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$message" >> "$LOG_FILE"
}

require_command() {
    local command_name="$1"
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command_name" >&2
        return 1
    fi
}

require_root() {
    if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
        printf 'This operation requires administrator privileges.\n'
        printf 'Run the toolkit with: sudo ./main.sh\n'
        return 1
    fi
}

confirm_action() {
    local prompt="$1"
    local answer
    read -r -p "$prompt [y/N]: " answer
    [[ "$answer" == "y" || "$answer" == "Y" ]]
}

valid_username() {
    # Conservative Linux username validation.
    [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

valid_groupname() {
    [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

pause_module() {
    printf '\nPress ENTER to return to the menu...'
    read -r _
}

print_section() {
    printf '\n--- %s ---\n' "$1"
}
