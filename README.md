# Linux System Administration Toolkit

A Bash project for practicing common Linux system administration tasks from a command-line menu.

The toolkit is divided into different modules, each covering a specific area of Linux administration.

## Features

- **System monitoring:** Display memory usage, disk space, system uptime, load average and running processes.
- **User and group management:** View user accounts and groups, create and delete users and groups, and manage group membership.
- **Network information:** Display network interfaces, listening ports, test connectivity and inspect DNS configuration.
- **Service management:** List services and check, start or stop systemd services.
- **File and permission management:** Check directory sizes, search for files, view and change permissions, and create compressed backups.
- **Security and logs:** View system and authentication logs, and search for files and directories with world-writable permissions.
- **Activity logging:** Keep a record of toolkit operations in a user-specific log directory.

## Requirements

- Linux (tested in Ubuntu through WSL).
- Bash 4 or later.
- Standard Linux utilities such as `coreutils`, `findutils`, `procps` and `iproute2`.
- `systemd` for service management.
- `tar` for compressed backups.
- `ping` for connectivity tests.

Some operations require administrator privileges and may behave differently depending on the Linux distribution.

## Installation

Clone the repository:

```bash
git clone https://github.com/adrianalmazan/Linux-System-Administration-Toolkit.git
cd Linux-System-Administration-Toolkit
```

Give execution permission to the main script:

```bash
chmod +x main.sh
```

Run the toolkit:

```bash
./main.sh
```

The toolkit should normally be run without root privileges. Administrative permissions are needed only for certain operations.

## Project structure

```text
Linux-System-Administration-Toolkit/
├── main.sh
├── modules/
│   ├── common.sh
│   ├── system_monitoring.sh
│   ├── user_management.sh
│   ├── network_management.sh
│   ├── service_management.sh
│   ├── file_management.sh
│   └── security_logs.sh
├── config/
├── logs/
├── .gitignore
└── README.md
```

## Author

Adrián Almazán