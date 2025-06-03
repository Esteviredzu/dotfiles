
# Create aliases
alias cls="clear"
alias m="micro"


set -U fish_greeting
set -gx EDITOR micro
set -gx VISUAL micro
set -gx BROWSER /usr/bin/firefox



set fish_color_command blue

if status is-interactive
    # Commands to run in interactive sessions can go here
    #wal -R &>/dev/null
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/archer/.lmstudio/bin
# End of LM Studio CLI section

