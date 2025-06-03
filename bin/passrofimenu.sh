#!/bin/sh

#DATABASE AND PASSWORD SECTION
DB="$HOME/mans/passwords.kdbx"
#DB_PASS=$(echo "" | rofi -dmenu -p "Enter KeePass password:")
DB_PASS='2eXa+sYA'


LAST_ENTRY_FILE="$HOME/.keepass_last_entry"


ENTRIES=$(echo "$DB_PASS" | keepassxc-cli ls "$DB" -f -R | sed 's/\r//g' | grep -v '/$')

if [ -f "$LAST_ENTRY_FILE" ]; then
    LAST_ENTRY=$(cat "$LAST_ENTRY_FILE")
    if echo "$ENTRIES" | grep -Fxq "$LAST_ENTRY"; then
        ENTRIES=$(echo -e "LAST:$LAST_ENTRY\n$ENTRIES" | awk '!seen[$0]++')
    fi
fi

ENTRY=$(echo "$ENTRIES" | rofi -dmenu -i -l 20 -p "Select entry:" | sed 's/^LAST://')

if [ -z "$ENTRY" ]; then
  echo "No entry selected, exiting."
  exit 1
fi

echo "$ENTRY" > "$LAST_ENTRY_FILE"

LOGIN=$(echo "$DB_PASS" | keepassxc-cli show "$DB" "$ENTRY" | grep "UserName" | awk -F: '{print $2}' | xargs)
PASSWORD=$(echo "$DB_PASS" | keepassxc-cli show -s "$DB" "$ENTRY" | grep "Password" | awk -F: '{print $2}' | xargs)
NOTES=$(echo "$DB_PASS" | keepassxc-cli show -s "$DB" "$ENTRY")
URL=$(echo "$DB_PASS" | keepassxc-cli show -s "$DB" "$ENTRY" | grep "URL" | awk -F: '{print $2}' | xargs)

echo "Login: $LOGIN"
echo "Password: $PASSWORD"
echo "NOTES: $NOTES"
echo "URL: $URL"

OPTIONS=""
[ -n "$LOGIN" ] && OPTIONS="$OPTIONS\nLogin"
[ -n "$PASSWORD" ] && OPTIONS="$OPTIONS\nPassword"
[ -n "$NOTES" ] && OPTIONS="$OPTIONS\nNotes"
[ -n "$URL" ] && OPTIONS="$OPTIONS\nURL"

if [ -z "$OPTIONS" ]; then
    notify-send "Error" "No data available for this entry"
    exit 1
fi

CHOICE=$(echo -e "${OPTIONS#\\n}" | rofi -dmenu -i -p "Select what to copy:")

case "$CHOICE" in
    "Login")
        echo -n "$LOGIN" | xclip -selection clipboard
        notify-send "Copied to clipboard" "Login copied"
        ;;
    "Password")
        echo -n "$PASSWORD" | xclip -selection clipboard
        notify-send "Copied to clipboard" "Password copied"
        ;;
    "Notes")
        echo -n "$NOTES" | xclip -selection clipboard
        notify-send "Copied to clipboard" "Notes copied"
        ;;
    "URL")
        echo -n "$URL" | xclip -selection clipboard
        notify-send "Copied to clipboard" "URL copied"
        ;;
    *)
        echo "No valid option selected, exiting."
        exit 1
        ;;
esac
