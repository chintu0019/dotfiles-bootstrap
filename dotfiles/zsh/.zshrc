# ── fzf completion & key-bindings ────────────────────────────────
if [ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi
if [ -f /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"

export FZF_DEFAULT_OPTS="
  --height 40% \
  --layout=reverse \
  --border \
  --info=inline \
  --preview='
    if [ -f {} ]; then
      bat --style=numbers --color=always {} | head -200
    else
      ls -la {} | head -100
    fi
  ' \
  --preview-window=right:50%
"

export FZF_CTRL_R_OPTS="
  --preview='echo {}' \
  --preview-window=up:3:wrap
"
# ───────────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
  wd
  systemadmin
  themes
  urltools
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  autojump
  fzf
)

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
#eval "$(starship init zsh)"

alias py="python3"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ── Local fzf pickers: print selection, no LBUFFER here ─────────────────

ff() {
  fd --type f --hidden --exclude .git . \
    | fzf --height=40% --layout=reverse --border \
          --preview='bat --style=numbers --color=always {} | head -200'
}

fdp() {
  fd --type d --hidden --exclude .git . \
    | fzf --height=40% --layout=reverse --border \
          --preview='ls -la {} | head -100'
}

fss() {
  awk '/^Host / {print $2}' ~/.ssh/config \
    | fzf --height=40% --layout=reverse --border --prompt="SSH> " \
          --preview="awk '/^Host {}$/{f=1;next} /^Host /{f=0} f' ~/.ssh/config"
}

fgr() {
  find ~ \
    \( -path ~/Library -o -path ~/.Trash -o -path ~/.cache \) -prune -o \
    -type d -name .git -print 2>/dev/null \
    | sed 's/\/\.git$//' \
    | fzf --height=40% --layout=reverse --border \
          --prompt="Git Repo> " \
          --preview='git -C {} log -n3 --oneline'
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
