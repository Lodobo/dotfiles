PROMPT='%{$fg_bold[cyan]%}%(!.#.$)%{$reset_color%} %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[magenta]%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$reset_color%}●"