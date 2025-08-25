# Ansible macOS Setup

A comprehensive Ansible playbook for automating macOS development environment setup and configuration.

## Overview

This repository contains Ansible roles and playbooks to automate the setup of macOS machines for development work. It handles both online and offline installations, making it suitable for air-gapped environments.

## Features

- **Bootstrap Configuration**: Passwordless sudo setup for automation
- **Package Managers**: Homebrew and MacPorts installation
- **Developer Tools**: Xcode, CMake, Ninja, LLVM, and more
- **Applications**: GUI applications via DMG installation (offline mode)
- **Command Line Tools**: Various CLI utilities and build tools
- **Dual Mode Support**: Online (Homebrew) and offline (DMG/ZIP) installation modes
- **Idempotent**: Safe to run multiple times

## Prerequisites

**IMPORTANT:**
Before running this playbook on a new Mac, you must install the Xcode Command Line Tools. Run the following command in Terminal and complete the installation:

```bash
xcode-select --install
```

This is required so that Python and other developer tools are available for Ansible to function. The playbook will also attempt to trigger this prompt and exit if Python is missing, but you must complete the installation manually before re-running the playbook.

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd ansible-macos-setup
   ```

2. **Install required collections:**
   ```bash
   ansible-galaxy collection install -r collections/requirements.yml
   ```

3. **Configure your inventory:**
   Edit `inventory.yml` to include your target machines.

4. **Run the playbook:**
   ```bash
   ansible-playbook -i inventory.yml playbook.yml --ask-become-pass
   ```

## Configuration

### Online Mode (Default)
Uses Homebrew to install packages from the internet:
```yaml
macos_config_offline_mode: false
```

### Offline Mode
Uses pre-downloaded DMG and ZIP files. **Note:** Large files are not included in this repository due to size limitations.

#### Setting Up Offline Mode

1. **Create the files directory:**
   ```bash
   mkdir -p roles/macos_config/files
   ```

2. **Download required files:**
   - Run the download script: `./download_files.sh`
   - Or manually download files listed below

3. **Required files for offline mode:**
   - `Xcode_15.4.xip` (from Apple Developer Portal)
   - `Xcode_16.4.xip` (from Apple Developer Portal)
   - `LLVM-19.1.7-macOS-ARM64.tar.xz` (from LLVM releases)
   - Various application DMG files (see task files for complete list)

4. **Enable offline mode:**
   ```yaml
   macos_config_offline_mode: true
   ```

## What Gets Installed

### Package Managers
- Homebrew (online mode)
- MacPorts (offline mode)

### Developer Tools
- Xcode (multiple versions supported)
- CMake
- Ninja build system
- LLVM 19.1.7
- GitLab Runner
- Python 3.13

### Applications
- Google Chrome
- Visual Studio Code
- iTerm2
- Obsidian
- Wireshark
- Podman Desktop
- Draw.io
- Kitty terminal
- MacVim
- Yubico Authenticator

### Command Line Tools
- Various Homebrew formulae (online mode)
- Pre-compiled binaries (offline mode)

## Project Structure

```
ansible-macos-setup/
├── inventory.yml              # Target machines
├── playbook.yml              # Main playbook
├── download_files.sh         # Script to download offline files
├── collections/
│   └── requirements.yml      # Ansible collections
├── roles/
│   └── macos_config/         # Main role
│       ├── defaults/         # Default variables
│       ├── files/           # DMG, ZIP, and other files (not in repo)
│       ├── tasks/           # Task files
│       └── vars/            # Variable definitions
└── README.md
```

## File Management

### Large Files
Due to GitHub's file size limitations, large files (DMGs, XIPs, etc.) are not included in this repository. These files are excluded via `.gitignore`.

### Offline Files
For offline installations, you need to manually download the required files and place them in `roles/macos_config/files/`. The `download_files.sh` script provides guidance on what files are needed.

### File Sources
- **Xcode**: Download from [Apple Developer Portal](https://developer.apple.com/download/)
- **LLVM**: Download from [LLVM releases](https://releases.llvm.org/)
- **Applications**: Download DMG files from official websites
- **Other tools**: Download from respective project websites

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Support

For issues and questions, please open an issue on GitHub.
