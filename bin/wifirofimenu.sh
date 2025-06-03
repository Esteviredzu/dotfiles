#!/bin/sh

# Wi-Fi status check
wifi_status=$(nmcli radio wifi)

if [ "$wifi_status" = "enabled" ]; then
    wifi_toggle="🔌 Turn off Wi-Fi"
else
    wifi_toggle="📶 Turn on Wi-Fi"
fi

# Action selection menu
choice=$(echo -e "📡 Connect to network\n$wifi_toggle\n💾 Saved networks list" | rofi -dmenu -p "Select action:")

case "$choice" in
    "📡 Connect to network")
        bssid=$(nmcli -f BSSID,SSID,SIGNAL,RATE,BARS,SECURITY dev wifi list | sed -n '1!p' | rofi -dmenu -p "Select Wi-Fi: " -l 20 | awk '{print $1}')
        [ -z "$bssid" ] && exit 0  # Exit if no network selected
        
        # Check if the network is secured (has WPA or similar)
        security=$(nmcli -f SECURITY dev wifi list | grep "$bssid" | awk '{print $1}')
        
        if [[ "$security" == *"WPA"* || "$security" == *"WEP"* ]]; then
            nmcli device wifi connect "$bssid" --ask
        else
            nmcli device wifi connect "$bssid"
        fi
        ;;

    "🔌 Turn off Wi-Fi")
        nmcli radio wifi off
        notify-send "Wi-Fi" "Turned off"
        ;;

    "📶 Turn on Wi-Fi")
        nmcli radio wifi on
        notify-send "Wi-Fi" "Turned on"
        ;;

    "💾 Saved networks list")
        ssid=$(nmcli connection show | awk -F'  +' 'NR>1 {print $1}' | rofi -dmenu -p "Select network:" -l 10)
        [ -z "$ssid" ] && exit 0  # Exit if no network selected
        
        action=$(echo -e "📋 Copy password\n🗑️ Delete network" | rofi -dmenu -p "Action:")
        
        case "$action" in
            "📋 Copy password")
                password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ssid")
                if [ -n "$password" ]; then
                    echo -n "$password" | xclip -selection clipboard
                    notify-send "Password for $ssid" "$password"
                else
                    notify-send "Error" "Password not found"
                fi
                ;;

            "🗑️ Delete network")
                nmcli connection delete "$ssid"
                notify-send "Network deleted" "$ssid"
                ;;
        esac
        ;;
esac
