#!/usr/bin/env bash

file_management_menu() {
    local option path destination
    while true; do
        printf '\n=== FILE AND PERMISSION MANAGEMENT ===\n'
        cat <<'MENU'
1. Show directory size
2. Find files by name
3. Display file permissions and ownership
4. Change file permissions (chmod)
5. Create a compressed backup of a directory
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                read -r -p "Directory path: " path
                if [[ -d "$path" ]]; then
                    du -sh -- "$path"
                    log_action "Checked directory size: $path"
                else
                    printf 'Directory does not exist.\n'
                fi
                pause_module
                ;;
            2)
                read -r -p "Directory to search: " path
                read -r -p "Filename pattern (e.g. *.log): " destination
                if [[ -d "$path" && "$destination" != "" && "$destination" != *"/"* ]]; then
                    find "$path" -type f -name "$destination" -print 2>/dev/null
                    log_action "Searched files in $path with pattern $destination"
                else
                    printf 'Invalid directory or filename pattern.\n'
                fi
                pause_module
                ;;
            3)
                read -r -p "File or directory path: " path
                if [[ -e "$path" ]]; then
                    stat -c 'Path: %n%nOwner: %U%nGroup: %G%nPermissions: %A (%a)%nType: %F' -- "$path"
                    log_action "Viewed permissions: $path"
                else
                    printf 'Path does not exist.\n'
                fi
                pause_module
                ;;
            4)
                read -r -p "File or directory path: " path
                read -r -p "Permission mode (e.g. 640 or 755): " destination
                if [[ -e "$path" && "$destination" =~ ^[0-7]{3,4}$ ]]; then
                    printf 'Current permissions: '
                    stat -c '%a' -- "$path"
                    if confirm_action "Apply chmod $destination to '$path'?"; then
                        if chmod "$destination" -- "$path"; then
                            printf 'Permissions updated.\n'
                            log_action "Changed permissions on $path to $destination"
                        else
                            printf 'Could not change permissions.\n'
                        fi
                    fi
                else
                    printf 'Invalid path or permission mode.\n'
                fi
                pause_module
                ;;
            5)
                read -r -p "Directory to back up: " path
                if [[ -d "$path" ]]; then
                    mkdir -p "$HOME/linux-admin-backups"
                    local archive="$HOME/linux-admin-backups/backup_$(date '+%Y%m%d_%H%M%S').tar.gz"
                    if tar -czf "$archive" -C "$(dirname -- "$path")" -- "$(basename -- "$path")"; then
                        printf 'Backup created: %s\n' "$archive"
                        log_action "Created backup of $path at $archive"
                    else
                        printf 'Backup failed.\n'
                    fi
                else
                    printf 'Directory does not exist.\n'
                fi
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
