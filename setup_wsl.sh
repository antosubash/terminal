#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting ZSH and Oh My Zsh setup..."

# Install ZSH and Git if not already installed
echo "📦 Installing ZSH and Git..."
sudo apt update
sudo apt install -y zsh git

# Check ZSH version
echo "📊 Checking ZSH version..."
zsh --version

# Change default shell to ZSH
echo "🔄 Changing default shell to ZSH..."
chsh -s $(which zsh)

# Install Oh My Zsh
echo "📥 Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh-syntax-highlighting
echo "📥 Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions
echo "📥 Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Configure .zshrc with plugins
echo "⚙️ Configuring .zshrc..."
cat > ~/.zshrc << 'EOL'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
EOL

# Source the new configuration
echo "🔄 Loading new configuration..."
source ~/.zshrc

echo "✅ Setup complete! Please log out and log back in for the changes to take effect."
echo "💡 After logging back in, your new ZSH shell will be ready to use!"
