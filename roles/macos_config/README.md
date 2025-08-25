# macos_config Ansible Role

**IMPORTANT:**
Before running this playbook on a new Mac, you must install the Xcode Command Line Tools. Run the following command in Terminal and complete the installation:

```
xcode-select --install
```

This is required so that Python and other developer tools are available for Ansible to function. The playbook will also attempt to trigger this prompt and exit if Python is missing, but you must complete the installation manually before re-running the playbook.

---

This role configures macOS machines (local or remote):

- Installs one or more custom Xcode versions (with versioned .xip support, idempotency, and license acceptance)
- Installs Homebrew and MacPorts (online or offline)
- Installs CLI tools and GUI apps (offline via DMG/.pkg/manual or online via Homebrew)
- Installs LLVM 19.1.7 and Ninja 1.12.1 to /opt (offline mode)

## ✅ Usage

### Local machine
```yaml
- hosts: localhost
  roles:
    - macos_config
```

### Remote machines
```yaml
- hosts: macbook-pro
  roles:
    - macos_config
```

### Multiple machines
```yaml
- hosts: macs
  roles:
    - macos_config
```

## 🔧 Remote Machine Configuration

### Inventory Setup
Edit `inventory.yml` to add your remote machines:

```yaml
all:
  hosts:
    # Local machine
    localhost:
      ansible_connection: local
    
    # Remote macOS machines
    macbook-pro:
      ansible_host: 192.168.1.100
      ansible_user: admin
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_become: yes
      ansible_become_method: sudo
      ansible_become_user: root
      ansible_become_password: "{{ vault_sudo_password }}"
```

### SSH Key Setup
1. Generate SSH key: `ssh-keygen -t rsa -b 4096`
2. Copy to remote: `ssh-copy-id admin@192.168.1.100`
3. Test connection: `ssh admin@192.168.1.100`

### Variables
- `macos_config_target_user`: Remote user (defaults to `ansible_user` or `admin`)
- `macos_config_target_home`: User home directory (`/Users/{{ macos_config_target_user }}`)
- `macos_config_target_shell_profile`: Shell profile path (`{{ macos_config_target_home }}/.zprofile`)

## ⚙️ Xcode Multi-Version Support
- Place your `.xip` files in `roles/macos_config/files/`.
- Configure versions in `defaults/main.yml`:

```yaml
macos_config_xcodes:
  - version: "15.4"
    xip_path: "{{ role_path }}/files/Xcode_15.4.xip"
    app_path: "/Applications/Xcode_15.4.app"
    set_active: true
  - version: "16.4"
    xip_path: "{{ role_path }}/files/Xcode_16.4.xip"
    app_path: "/Applications/Xcode_16.4.app"
    set_active: false
```
- The playbook will install all listed versions and set the one with `set_active: true` as the active developer directory.

## 🛠️ Developer Tools: Online & Offline

### Offline (DMG/.pkg/manual)
- All DMG, .pkg, and manual installs are in `tasks/developer_tools_offline.yml`.
- Each tool is installed idempotently (only if not already present).
- To add a new DMG or .pkg, copy the pattern for existing tools (see Obsidian, CMake, etc.).

### Online (Homebrew)
- All Homebrew-based installs are in `tasks/developer_tools_online.yml`.
- To add a new Homebrew tool, add it to the `name:` list in the Homebrew task.
- Homebrew installs run as your user (not root).

### Switching Modes
- The playbook automatically includes the correct file based on `macos_config_offline_mode`.

```yaml
- name: Install developer tools (offline)
  ansible.builtin.include_tasks: developer_tools_offline.yml
  when: macos_config_offline_mode

- name: Install developer tools (online)
  ansible.builtin.include_tasks: developer_tools_online.yml
  when: not macos_config_offline_mode
```

## ⚙ Custom LLVM, Ninja, MacPorts
Tool versions are managed via variables in `defaults/main.yml`:
- LLVM: 19.1.7 (installed to /opt/llvm)
- Ninja: 1.12.1 (installed to /opt/ninja)
- MacPorts: 2.11.0-15

To use different versions, override the variables:
```yaml
- hosts: mymac
  roles:
    - role: macos_config
      vars:
        macos_config_llvm_version: "20.0.0"
        macos_config_ninja_version: "1.13.0"
```

## 🚀 Deployment Examples

### Single Remote Machine
```bash
ansible-playbook -i inventory.yml playbook.yml --limit macbook-pro
```

### All Machines
```bash
ansible-playbook -i inventory.yml playbook.yml
```

### Offline Mode
```yaml
- hosts: macbook-pro
  roles:
    - role: macos_config
      vars:
        macos_config_offline_mode: true
```

## 🧹 Idempotency & Linting
- All install tasks are idempotent (safe to re-run).
- To lint your playbook:
```bash
ansible-lint .
```

## 📝 Adding New Tools
- **Offline:** Add a new DMG/.pkg block to `developer_tools_offline.yml`.
- **Online:** Add the tool name to the Homebrew list in `developer_tools_online.yml`.

---

For any questions or contributions, open an issue or PR!
