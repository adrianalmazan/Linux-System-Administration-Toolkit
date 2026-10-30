#!/usr/bin/env bash

user_management_menu() {
    local option username groupname
    while true; do
        printf '\n=== USER AND GROUP MANAGEMENT ===\n'
        cat <<'MENU'
1. List logged-in users
2. Display user information
3. Create a user
4. Delete a user
5. Create a group
6. Add a user to a supplementary group
7. List groups for a user
0. Back
MENU
        read -r -p "Select an option: " option

        case "$option" in
            1)
                print_section "Logged-in users"
                who
                log_action "Listed logged-in users"
                pause_module
                ;;
            2)
                read -r -p "Username: " username
                if id "$username" >/dev/null 2>&1; then
                    id "$username"
                    getent passwd "$username"
                    log_action "Viewed account information for $username"
                else
                    printf 'User does not exist.\n'
                fi
                pause_module
                ;;
            3)
                require_root || { pause_module; continue; }
                read -r -p "New username: " username
                if ! valid_username "$username"; then
                    printf 'Invalid username format.\n'
                elif id "$username" >/dev/null 2>&1; then
                    printf 'User already exists.\n'
                elif confirm_action "Create user '$username'?"; then
                    if useradd -m -s /bin/bash "$username"; then
                        printf 'User created. Set a password with: passwd %s\n' "$username"
                        log_action "Created user $username"
                    else
                        printf 'User creation failed.\n'
                    fi
                fi
                pause_module
                ;;
            4)
                require_root || { pause_module; continue; }
                read -r -p "Username to delete: " username
                if ! valid_username "$username" || ! id "$username" >/dev/null 2>&1; then
                    printf 'Invalid username or user does not exist.\n'
                elif [[ "$username" == "root" || "$username" == "$SUDO_USER" ]]; then
                    printf 'Refusing to delete root or the invoking administrator account.\n'
                elif confirm_action "Delete user '$username' and their home directory?"; then
                    if userdel -r "$username"; then
                        printf 'User deleted.\n'
                        log_action "Deleted user $username"
                    else
                        printf 'User deletion failed.\n'
                    fi
                fi
                pause_module
                ;;
            5)
                require_root || { pause_module; continue; }
                read -r -p "New group name: " groupname
                if ! valid_groupname "$groupname"; then
                    printf 'Invalid group name format.\n'
                elif getent group "$groupname" >/dev/null; then
                    printf 'Group already exists.\n'
                elif confirm_action "Create group '$groupname'?"; then
                    if groupadd "$groupname"; then
                        printf 'Group created.\n'
                        log_action "Created group $groupname"
                    else
                        printf 'Group creation failed.\n'
                    fi
                fi
                pause_module
                ;;
            6)
                require_root || { pause_module; continue; }
                read -r -p "Username: " username
                read -r -p "Supplementary group: " groupname
                if ! id "$username" >/dev/null 2>&1 || ! getent group "$groupname" >/dev/null; then
                    printf 'User or group does not exist.\n'
                elif confirm_action "Add '$username' to supplementary group '$groupname'?"; then
                    if usermod -aG "$groupname" "$username"; then
                        printf 'User added to group. A new login session may be required.\n'
                        log_action "Added $username to group $groupname"
                    else
                        printf 'Could not add user to group.\n'
                    fi
                fi
                pause_module
                ;;
            7)
                read -r -p "Username: " username
                if id "$username" >/dev/null 2>&1; then
                    groups "$username"
                    log_action "Listed groups for $username"
                else
                    printf 'User does not exist.\n'
                fi
                pause_module
                ;;
            0) return ;;
            *) printf 'Invalid option.\n' ;;
        esac
    done
}
