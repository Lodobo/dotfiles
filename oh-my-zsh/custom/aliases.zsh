# ALIASES
alias open="xdg-open 2>/dev/null"
alias zshrc="hx ~/.zshrc"
alias zsh-alias="hx $ZSH/custom/aliases.zsh"
alias z="zellij"

# Get a help page for CLI coomands.
alias h="curl -sL 'https://raw.githubusercontent.com/Lodobo/linux-help-pages/main/files/help.man' | man -l -"

# FUNCTIONS
function lvf() {
  # list visible files
  find $1 -maxdepth 1 -type f ! -name '.*' | sed 's|.*/||' | sort
}
function lvd() {
  # list visible directories
  find $1 -maxdepth 1 -type d ! -name '.*' | sed 's|.*/||' | sort
}
function lhf() {
  # List hidden files
  find $1 -maxdepth 1 -type f -name '.*' | sed 's|.*/||' | sort
}
function lhd() {
  # List hidden directories
  find $1 -maxdepth 1 -type d -name '.*' -not -name '.' | sed 's|./||' | sort
}
function zipsize () {
    # Print the compressed and uncompressed size of an archive.
    compressed_size=$(echo $(du -h $1)iB | sed "s/ $1//g" | sed "s/MiB/ MiB/g")
    uncompressed_size=$(unzip -l $1 | tail -1 | xargs | cut -d' ' -f1 | numfmt --to=iec-i --suffix=B | sed "s/MiB/ MiB/g" | sed "s/GiB/ GiB/g")
    echo compressed: $compressed_size
    echo uncompressed: $uncompressed_size
}
function fm() {
  # Use the joshuto file manager and change directory on exit.
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
function change-theme() {
	# Change the theme of alacritty, helix and zellij simultaneously.
	local THEME="$1"
	local VALID_OPTIONS=("ayu-dark" "ayu-light" "default-dark" "default-light" "dracula" "kanagawa" "monokai" "nord" "one-dark" "one-light" "solarized-dark" "solarized-light")

	if [[ "${VALID_OPTIONS[*]}" == *"$THEME"* ]]; then

		# Change alacritty config
		sed -i "s|~/.config/alacritty/themes/[^.]*\\.yml|~/.config/alacritty/themes/${THEME}.yml|" ~/.config/alacritty/alacritty.yml

		# Change helix config
		sed -i "s|theme = \"[^\"]*\"|theme = \"$THEME\"|" ~/.config/helix/config.toml

		# Change zellij config
		sed -i "s|theme \"[^\"]*\"|theme \"$THEME\"|" ~/.config/zellij/config.kdl

  else
    echo "Valid options: \n"
		echo $VALID_OPTIONS
  fi
}
