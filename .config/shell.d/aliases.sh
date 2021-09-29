#!/usr/bin/env sh
alias ka="killall" \
	mkd="mkdir -pv" \
	mpv="mpv --input-ipc-server=/tmp/mpvsoc$(date +%s)" \
	SS="sudo systemctl" \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto -E" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi" \
	yt="youtube-dl --add-metadata -i -o '%(upload_date)s-%(title)s.%(ext)s'" \
	yta="yt -x -f bestaudio/best" \
	cp="cp --reflink=auto" \
	
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Stop making me type sudo!
alias \
    pacman="sudo pacman" \
    dnf="sudo dnf" \
    apt="sudo apt" \
    firewall='sudo firewall-cmd' \
    fw='firewall' \