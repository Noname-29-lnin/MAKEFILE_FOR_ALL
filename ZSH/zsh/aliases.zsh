# ==============================================================================
# Navigation
# ==============================================================================
alias ll="ls -alF"
alias la="ls -A"
alias b="cd .."
alias bb="cd ../.."
alias bbb="cd ../../.."
alias bbbb="cd ../../../.."
alias z="cd -"
alias c="clear; ls -a1"

# ==============================================================================
# System
# ==============================================================================
alias update="sudo apt update"
alias update_upgrade="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"

# ==============================================================================
# Shortkeys for Setup (Dùng ~/.config/nvim thay vì ~/.config để tránh mở lộn thư mục)
# ==============================================================================
alias nvimconfig="nvim ~/.config/nvim"
alias zshconfig="nvim ~/.zshrc"
alias p10kconfig="nvim ~/.p10k.zsh"

# ==============================================================================
# Editor & Multiplexer
# ==============================================================================
alias nv="nvim"
alias vim="nvim"

alias tmux_new="tmux new -s"
alias tmux_attach="tmux attach -t"
alias tmux_kill="tmux kill-session -t"

alias config_icon_desktop="nvim ~/.local/share/applications"
alias update_icon_desktop="update-desktop-database ~/.local/share/applications/"

# ==============================================================================
# Install & Update
# ==============================================================================
## Docker
alias docker_hold_update="sudo apt-mark hold docker-ce"
alias docker_unhold_update="sudo apt-mark unhold docker-ce"
alias docker_update="sudo apt update && sudo apt install --only-upgrade docker-ce"
alias docker_stop_all_containers="docker container stop $(docker container ls -aq)"
alias docker_remove_all_containers="docker container rm $(docker container ls -aq)"
alias docker_remove_all_objects="docker system prune -a --volumes -f"
alias docker_remove_all_packages="sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras; sudo apt autoremove"
alias docker_remove_all_files="sudo rm -rf /var/lib/{docker,containerd}"
## Wireguard
alias wireguard_up='sudo systemctl start wg-quick@wg0'
alias wireguard_down='sudo systemctl stop wg-quick@wg0'
alias wireguard_status='systemctl status wg-quick@wg0'
alias wireguard_log='journalctl -u wg-quick@wg0 -f'
alias wireguard_restart='sudo systemctl restart wg-quick@wg0'
alias wireguard_show='sudo wg show wg0'
alias wireguard_reload='sudo systemctl daemon-reload'

# To Remove only Free Claude Code (not uv, Claude Code, Codex, or the uv-managed Python runtime):
alias free_claude_code_uninstall="curl -fsSL "https://raw.githubusercontent.com/Alishahryar1/free-claude-code/main/scripts/uninstall.sh" | sudo sh"
