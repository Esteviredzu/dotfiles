#!/usr/bin/bash

# Определяем список опций с иконками
options="\n\n\n\n"

# Вызываем rofi без поиска и с иконками
selected_option=$(echo -e "$options" | rofi -theme ~/.config/rofi/power.rasi -dmenu -i -p "Choose an action:")

# Обработка выбора
case "$selected_option" in
    "")
        shutdown 0
        ;;
    "")
        reboot
        ;;
    "")
        systemctl suspend
        ;;
    "")
        bspc quit
        ;;
    "")
        dm-tool lock
        ;;
    *)
        echo "Invalid option selected"
        ;;
esac

exit 0
