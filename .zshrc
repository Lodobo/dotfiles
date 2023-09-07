# .zshrc

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# add homebrew related things to path
eval "$(brew shellenv)"
# eval "$(zellij setup --generate-auto-start bash)"

# ZSH THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# PLUGINS
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ENVIRONMENT VARIABLES
export TERM="alacritty"
export CLICOLOR=1
export LESSCHARSET="utf-8"
export VIMINIT='source $MYVIMRC'
export MYVIMRC='~/.config/vim/vimrc'
export HOMEBREW_NO_ENV_HINTS=true
export HOMEBREW_GITHUB_API_TOKEN="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"

# PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/silvere/.local/bin:$PATH"
# export PATH="/Applications/ln:$PATH"

# ALIASES
alias zsh="hx ~/.zshrc"
alias lvf="find . -maxdepth 1 -type f ! -name '.*' | sed 's|.*/||' | sort"
alias lvd="find . -maxdepth 1 -type d ! -name '.*' | sed 's|.*/||' | sort"
alias lhf="find . -maxdepth 1 -type f -name '.*' | sed 's|.*/||' | sort"
alias lhd="find . -maxdepth 1 -type d -name '.*' -not -name '.' | sed 's|./||' | sort"
alias fzf="sk"
alias dt="detach"
alias path="realpath"
alias t="tree-rs"
alias pipes="pipes-rs -k curved"
alias fetch="clear && macchina"
alias help="man ~/.local/share/help.man"
alias music="musikcube"
alias z="zellij"

# FUNCTIONS

zipsize () {
    compressed_size=$(echo $(du -h $1)iB | sed "s/ $1//g" | sed "s/MiB/ MiB/g")
    uncompressed_size=$(unzip -l $1 | tail -1 | xargs | cut -d' ' -f1 | numfmt --to=iec-i --suffix=B | sed "s/MiB/ MiB/g" | sed "s/GiB/ GiB/g")
    echo compressed: $compressed_size
    echo uncompressed: $uncompressed_size
}

function pix() {
	open -a /Applications/imageviewer5.app $@
}


function fm() {
	ID="$$"
	mkdir -p /tmp/$USER
	OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
	env joshuto --change-directory --output-file "$OUTPUT_FILE" $@
	exit_code=$?

	case "$exit_code" in
		# regular exit
		0)
			;;
		# output contains current directory
		101)
			JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD"
			;;
		# output selected files
		102)
			;;
		*)
			echo "Exit code: $exit_code"
			;;
	esac
}


playurl() {
  local parent_url="$1"

  # Create the playlist directory if it doesn't exist
  mkdir -p "/tmp/playurl"

  # Retrieve the filenames and save them to the playlist file
  curl -s "$parent_url" | sed -nE 's#.*href="([^"]*\.mkv|[^"]*\.mp4)".*#'"$parent_url"'\1#p' > /tmp/playurl/playlist.m3u

	iina /tmp/playurl/playlist.m3u
}

chtheme() {
	# Change the theme of alacritty, helix and zellij simultaneously.
	local THEME="$1"
	local VALID_OPTIONS=("ayu-dark" "ayu-light" "default-dark" "default-light" "dracula" "kanagawa" "monokai" "nord" "one-dark" "one-light" "solarized-dark" "solarized-light")
	

	if [[ "${VALID_OPTIONS[*]}" == *"$THEME"* ]]; then

		# Change alacritty config		
		sed -i '' "s|~/.config/alacritty/themes/[^.]*\\.yml|~/.config/alacritty/themes/${THEME}.yml|" ~/.config/alacritty/alacritty.yml

		# Change helix config
		sed -i '' "s|theme = \"[^\"]*\"|theme = \"$THEME\"|" ~/.config/helix/config.toml

		# Change zellij config
		sed -i '' "s|theme \"[^\"]*\"|theme \"$THEME\"|" ~/.config/zellij/config.kdl

  else
    echo "Valid options: \n"
		echo $VALID_OPTIONS
  fi
}
