#DESCRIPTION:  A nicer default shell prompt line


#DESCRIPTION:  Use full block cursor       Do not use full block cursor
#USAGE         block-on                    block-off

#DESCRIPTION:  Print username              Do not print username              Set colour of username
#USAGE:        username-on                 username-off                       username-colour <ansi-colour>

#DESCRIPTION:  Print hostname              Do not print hostname              Set colour of hostname
#USAGE:        hostname-on                 hostname-off                       hostname-colour <ansi-colour>

#DESCRIPTION:  Print IP address in place hostname
#USAGE:        hostname-ip

#DESCRIPTION:  Print terminal name         Do not print terminal name         Set colour of terminal name
#USAGE:        pts-on                      pts-off                            pts-colour <ansi-colour>

#DESCRIPTION:  Print git branch            Do not print git branch            Set colour of git branch
#USAGE:        git-on                      git-off                            git-colour <ansi-colour>

#DESCRIPTION:  Print directory             Do not print directory             Set colour of directory
#USAGE:        dir-on                      dir-off                            dir-colour <ansi-colour>

#DESCRIPTION:  Print directory tip         Print absolute directory           Print custom directory
#USAGE:        dir-short                   dir-full                           dir-text <text>

#DESCRIPTION:  Print current time          Do not print current time          Set colour of current time
#USAGE:        clock-on                    clock-off                          clock-colour <ansi-colour>

#DESCRIPTION:  Print battery status        Do not print battery status        Set colour of battery status
#USAGE:        battery-on                  battery-off                        battery-colour <ansi-colour>

#DESCRIPTION:  Print featherweight status  Do not print featherweight status  Set the used colour
#USAGE         featherweight-on            featherweight-off                  featherweight-colour <ansi-colour>

#DESCRIPTION:  Set title on terminal       Do not set title on terminal
#USAGE         title-on                    title-off

#DESCRIPTION:  Use two lines               Use a single line
#USAGE         dual-on                     dual-off

#DESCRIPTION:  Set colour of error code
#USAGE         error-colour <ansi-colour>

#DESCRIPTION:  Set colour of dollar/hash sign
#USAGE         dollar-colour <ansi-colour>


prompt_addons=()


__prompt_block=""
if [ "$TERM" = "linux" ]; then
    __prompt_block="\033[?8c"
fi
block-on () {
    __prompt_block="\033[?8c"
    update-prompt
}
block-off () {
    __prompt_block=""
    update-prompt
}


__prompt_username="\u"
username-on () {
    __prompt_username="\u"
    update-prompt
}
username-off () {
    __prompt_username=""
    update-prompt
}


__prompt_username_colour="94"
if [ "$USER" = "root" ]; then
    __prompt_username_colour="91"
    if [ "$TERM" = "linux" ]; then
        __prompt_username_colour="31;01"
    fi
elif [ "$TERM" = "linux" ]; then
    __prompt_username_colour="34;01"
fi
username-colour () {
    __prompt_username_colour="$*"
    update-prompt
}


__prompt_hostname="1"
hostname-on () {
    __prompt_hostname="1"
    update-prompt
}
hostname-ip () {
    __prompt_hostname="$( (ifconfig | sed -n 's/^[\t ]*inet[\t ][\t ]*\([^\t ]*\).*$/\1/p' |
                          sed '/^127\.0\.0\.1$/d' ; echo 127.0.0.1) | sed 1q )"
    update-prompt
}
hostname-off () {
    __prompt_hostname="0"
    update-prompt
}


__prompt_hostname_colour="34"
hostname-colour () {
    __prompt_hostname_colour="$*"
    update-prompt
}


__prompt_pts="0"
if [ "$TERM" = "linux" ]; then
    __prompt_pts="1"
fi
pts-on () {
    __prompt_pts="1"
    update-prompt
}
pts-off () {
    __prompt_pts="0"
    update-prompt
}


__prompt_pts_colour="36"
pts-colour () {
    __prompt_pts_colour="$*"
    update-prompt
}


__prompt_git="1"
git-on () {
    __prompt_git="1"
    update-prompt
}
git-off () {
    __prompt_git="0"
    update-prompt
}


__prompt_git_colour="32"
git-colour () {
    __prompt_git_colour="$*"
    update-prompt
}


__git () {
    exec 2>/dev/null
    if git status >&2; then
	status="$(git status -s -b | head -n 1)"
	if [ "$(echo "${status}" | cut -d ' ' -f 3)" = '[ahead' ]; then
	    echo "${status}" | cut -d ' ' -f 2
	else
	    echo "${status}" | cut -d ' ' -f 2 | cut -d . -f 1
	fi
    fi
}


__prompt_dir="\w"
dir-on () {
    __prompt_dir="\w"
    update-prompt
}
dir-short () {
    __prompt_dir="\W"
    update-prompt
}
dir-full () {
    __prompt_dir='$(pwd)'
    update-prompt
}
dir-text () {
    __prompt_dir="$(sed -e 's:\\:\\\\:g' <<<"$*")"
    update-prompt
}
dir-off () {
    __prompt_dir=""
    update-prompt
}


__prompt_dir_colour="35"
dir-colour () {
    __prompt_dir_colour="$*"
    update-prompt
}


__prompt_clock="(\t)"
clock-on () {
    __prompt_clock="(\t)"
    update-prompt
}
clock-off () {
    __prompt_clock=""
    update-prompt
}


__prompt_clock_colour="33"
clock-colour () {
    __prompt_clock_colour="$*"
    update-prompt
}


__prompt_dual="\[\033[00m\]\n\[\033[1K\]"
dual-on () {
    __prompt_dual="\[\033[00m\]\n\[\033[1K\]"
    update-prompt
}
dual-off () {
    __prompt_dual=""
    update-prompt
}


__prompt_dollar_colour="01;34"
if [ "$USER" = "root" ]; then
    __prompt_dollar_colour="01;31"
fi
dollar-colour () {
    __prompt_dollar_colour="$*"
    update-prompt
}


__prompt_error_colour="01;31"
error-colour () {
    __prompt_error_colour="$*"
    update-prompt
}


__error () {
    if [ "$1" = "0" ]; then
        echo -n ""
    else
        echo -n "(error: $1) "
    fi
}


__prompt_battery=""
battery-on () {
    __prompt_battery='$(__battery)'
    update-prompt
}
battery-off () {
    __prompt_battery=""
    update-prompt
}


__prompt_battery_colour="33"
battery-colour () {
    __prompt_battery_colour="$*"
    update-prompt
}


__battery () {
    local __first=1
    acpi --battery 2>/dev/null | while read info; do
        if [ $__first = 1 ]; then
            echo -n "(${info})"
            __first=0
        else
            echo -n " (${info})"
        fi
    done
}


__prompt_featherweight='$(__featherweight)'
featherweight-on () {
    __prompt_featherweight='$(__featherweight)'
    update-prompt
}
featherweight-off () {
    __prompt_featherweight=''
    update-prompt
}


__prompt_featherweight_colour="36"
featherweight-colour () {
    __prompt_featherweight_colour="$*"
    update-prompt
}


__featherweight () {
    local status
    if [ -r ~/.var/lib/featherweight/status ]; then
       status="$(cat ~/.var/lib/featherweight/status)"
       if [ ! "${status}" = "0" ]; then
	   echo "(fw: ${status})"
       fi
    fi
}


__prompt_title=""
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
	__prompt_title="\033]0;\u@\h: \w  ||  $(tty)\a"
	;;
esac
title-on () {
    __prompt_title="\033]0;\u@\h: \w  ||  $(tty)\a"
    update-prompt
}
title-off () {
    __prompt_title=""
    update-prompt
}


__screen_title=""
case "$TERM" in
    screen)
	__screen_title="\033_\u@\h: \w  ||  $(tty)\033\\"
	;;
esac
screen-title-on () {
    __screen_title="\033_\u@\h: \w  ||  $(tty)\033\\"
    update-prompt
}
screen-title-off () {
    __screen_title=""
    update-prompt
}


update-prompt () {
    local __invisible __addon
    __invisible="\[${__prompt_title}${__screen_title}${__prompt_block}\033[00m\]"
    PS1=""
    if [ ! "${__prompt_username}" = "" ]; then
        PS1="${PS1}\[\033[${__prompt_username_colour}m\]${__prompt_username}\[\033[00m\]"
    fi
    if [ "${__prompt_hostname}" = "1" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1}@"
        fi
        PS1="${PS1}\[\033[${__prompt_hostname_colour}m\]\h\[\033[00m\]"
    elif [ ! "${__prompt_hostname}" = "0" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1}@"
        fi
        PS1="${PS1}\[\033[${__prompt_hostname_colour}m\]${__prompt_hostname}\[\033[00m\]"
    fi
    if [ "${__prompt_pts}" = "1" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1}."
        fi
        PS1="${PS1}\[\033[${__prompt_pts_colour}m\]\l\[\033[00m\]"
    fi
    if [ "${__prompt_git}" = "1" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1}"'$(git status 2>/dev/null >&2 && echo -n : || echo -n "")'
        fi
        PS1="${PS1}\[\033[${__prompt_git_colour}m\]"'$(__git)'"\[\033[00m\]"
    fi
    if [ ! "${__prompt_dir}" = "" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1}: "
        fi
        PS1="${PS1}\[\033[${__prompt_dir_colour}m\]${__prompt_dir}\[\033[00m\]"
    fi
    if [ ! "${__prompt_clock}" = "" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1} "
        fi
        PS1="${PS1}\[\033[${__prompt_clock_colour}m\]${__prompt_clock}\[\033[00m\]"
    fi
    if [ ! "${__prompt_battery}" = "" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1} "
        fi
        PS1="${PS1}\[\033[${__prompt_battery_colour}m\]${__prompt_battery}\[\033[00m\]"
    fi
    if [ ! "${__prompt_featherweight}" = "" ]; then
        if [ ! "${PS1}" = "" ]; then
            PS1="${PS1} "
        fi
        PS1="${PS1}\[\033[${__prompt_featherweight_colour}m\]${__prompt_featherweight}\[\033[00m\]"
    fi
    __sh="\[\033[00m\033[${__prompt_dollar_colour}m\]\\$\[\033[00m\]"
    __err="\[\033[${__prompt_error_colour}m\]"'$(__error $?)'"\[\033[00m\]"
    for __addon in "${prompt_addons[@]}"; do
	PS1="${PS1}$(${__addon})"
    done
    PS1="${__invisible}${__err}${PS1}${__prompt_dual}${__sh} "
}


update-prompt


PS2='\[\e[01;31m\]> \[\e[00m\]'
PS3='\[\e[01;31m\]> \[\e[00m\]'
PS4='\[\e[01;31m\]+ \[\e[00m\]'

