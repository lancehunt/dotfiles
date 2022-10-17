# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); for i in ${!paths[@]}; do if [[ ${paths[i]} == "'~/.pyenv/shims'" ]]; then unset '\''paths[i]'\''; fi; done; echo "${paths[*]}"')"
export PATH="~/.pyenv/shims:${PATH}"
command pyenv rehash 2>/dev/null
