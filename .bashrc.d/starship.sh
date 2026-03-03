
if [[ -z $ZSH ]]; then     
echo "test"
	if [ "${BASH_VERSINFO[0]}" -gt 4 ] || ([ "${BASH_VERSINFO[0]}" -eq 4 ] && [ "${BASH_VERSINFO[1]}" -ge 1 ])
	then
		source <("/home/svzieg/.local/bin/starship" init bash --print-full-init)
	else
		source /dev/stdin <<<"$("/home/svzieg/.local/bin/starship" init bash --print-full-init)"
	fi
else 
	source <("/home/svzieg/.local/bin/starship" init zsh --print-full-init)
fi
