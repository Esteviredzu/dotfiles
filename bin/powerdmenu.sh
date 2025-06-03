#!/usr/bin/bash

# Определяем список опций с иконками
options=" Shutdown\n Reboot\n Suspend\n Logout\n Lock"

# Вызываем dmenu без поиска и с иконками
selected_option=$(echo -e "$options" | dmenu -i -p "Choose an action:")

# Обработка выбора
case "$selected_option" in
    " Shutdown")
        shutdown 0
        ;;
    " Reboot")
        reboot
        ;;
    " Suspend")
        $HOME/.config/bin/i3lock-setup.sh
        systemctl suspend
        ;;
    " Logout")
        pkill -KILL -u $USER
        ;;
    " Lock")
        dm-tool lock
        ;;
    *)
        echo "Invalid option selected"
        ;;
esac

exit 0
