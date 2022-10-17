# Bail out if not running interactively
[[ $- != *i* ]] && return

##############################################################################
# Path
##############################################################################
export PATH=$PATH:~/.local/bin
export LESS=FRX
export EDITOR=vim

##############################################################################
## History
##############################################################################
HISTSIZE=15000           # How many lines of history to keep in memory
SAVEHIST=1000000000      # Number of history entries to save to disk
HISTFILE=~/.zsh_history  # Where to save history to disk
HISTDUP=erase            # Erase duplicates in the history file
setopt appendhistory     # Append history to the history file (no overwriting)
setopt sharehistory      # Share history across terminals
setopt incappendhistory  # Immediately append to the history file, not just when a term is killed

##############################################################################
## Ergonomics
##############################################################################
unsetopt BEEP # beeping is annoying
setopt autocd nomatch
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

##############################################################################
# Plugins
##############################################################################
# Download Znap, if it's not there yet.
export ZNAP_ROOT="$HOME/.local/share/zsh/plugins/zsh-snap"
[[ -f "$ZNAP_ROOT/znap.zsh" ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "$ZNAP_ROOT"

# Start Znap
source "$ZNAP_ROOT/znap.zsh"

znap source softmoth/zsh-vim-mode
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-syntax-highlighting
znap source joshskidmore/zsh-fzf-history-search

##############################################################################
# Completions
# See: https://superuser.com/questions/1092033/how-can-i-make-zsh-tab-completion-fix-capitalization-errors-for-directories-and
##############################################################################
#autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

##############################################################################
# Wezterm shell integration
##############################################################################
if [ -f "$HOME/.config/wezterm/shell_integration.sh" ]; then
  source "$HOME/.config/wezterm/shell_integration.sh"
fi

##############################################################################
# Prompt https://starship.rs
##############################################################################
if command -v starship &>/dev/null; then
  export STARSHIP_LOG=error
  eval "$(starship init zsh)"
fi

##############################################################################
# Developer Tools
##############################################################################

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

  

##############################################################################
# Python
##############################################################################
export PYENV_ROOT="$HOME/.pyenv"

if command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"; then
  eval "$(pyenv init -)"
fi

if command -v pipx &>/dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

if command -v pipenv &>/dev/null; then
  # Tell pipenv to create virtual environments inside the project directory
  export PIPENV_VENV_IN_PROJECT=1
fi


##############################################################################
# Source other Files
##############################################################################
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

[[ -f ~/.kubectl-profile ]] && source ~/.kubectl-profile
[[ -f ~/.aws-profile ]] && source ~/.aws-profile

