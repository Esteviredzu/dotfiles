#!/bin/bash

# Получаем информацию о процессоре, ОЗУ и ПЗУ
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
ram_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | awk '{print $1}')
disk_usage=$(df / | grep / | awk '{ print $5 }')

# Получаем информацию о батарее
battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')
battery_percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed 's/%//')
battery_icon="🔋"

# Иконки
cpu_icon=""
ram_icon=""
disk_icon=""

# Отправляем уведомление с иконками
notify-send "System Stats" "${cpu_icon} CPU: ${cpu_usage}% \n ${ram_icon} RAM: $(printf "%.1f" $ram_usage)% \n ${disk_icon} Disk: ${disk_usage} \n ${battery_icon} Battery: ${battery_percentage}% (${battery_status})"
