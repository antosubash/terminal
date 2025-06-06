# WSL ZSH Setup

This repository contains a setup script to configure ZSH with Oh My Zsh in WSL, including popular plugins and the Agnoster theme.

## Features

- ZSH shell installation
- Oh My Zsh framework
- Agnoster theme
- zsh-syntax-highlighting plugin
- zsh-autosuggestions plugin
- Git plugin

## Quick Install

Run this command in your WSL terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/antosubash/terminal/main/setup_wsl.sh | bash
```

## Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/antosubash/terminal.git
cd terminal
```

2. Make the script executable:
```bash
chmod +x setup_wsl.sh
```

3. Run the setup script:
```bash
./setup_wsl.sh
```

## Post-Installation

After running the script, you'll need to:
1. Log out of your WSL session
2. Log back in to start using ZSH

## Requirements

- WSL (Windows Subsystem for Linux)
- Ubuntu or Debian-based distribution
- Sudo privileges

## Customization

The script sets up the following configuration:
- Agnoster theme
- Git plugin
- zsh-syntax-highlighting
- zsh-autosuggestions

You can modify the `.zshrc` file after installation to customize your setup further.

## License

MIT
