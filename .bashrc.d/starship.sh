STARSHIP=$(command -v starship 2>/dev/null || echo "/home/svzieg/.local/bin/starship")

if [[ -z $ZSH ]]; then
	if [ "${BASH_VERSINFO[0]}" -gt 4 ] || { [ "${BASH_VERSINFO[0]}" -eq 4 ] && [ "${BASH_VERSINFO[1]}" -ge 1 ]; }; then
		# shellcheck disable=SC1090
		source <("$STARSHIP" init bash --print-full-init)
	else
		# shellcheck disable=SC1090
		source /dev/stdin <<<"$("$STARSHIP" init bash --print-full-init)"
	fi
else
	# shellcheck disable=SC1090
	source <("$STARSHIP" init zsh --print-full-init)
fi
