# This script is a modified version of:
#   qbittorrent-gluetun-port-update by TechnoSam
#   Original source: https://codeberg.org/TechnoSam/qbittorrent-gluetun-port-update
#   Licensed under AGPLv3: https://www.gnu.org/licenses/agpl-3.0.html
set -x
trap "echo Caught SIGTERM, exiting; exit 0" TERM

set -euo pipefail

QBITTORRENT_WEBUI_PASSWORD="$(<$QBITTORRENT_WEBUI_PASSWORD_FILE)"

echo "Starting qbittorent-vpn-port-update"
echo "Config:"
echo "VPN_INTERFACE=$VPN_INTERFACE"
echo "QBITTORRENT_WEBUI_HOST=$QBITTORRENT_WEBUI_HOST"
echo "QBITTORRENT_WEBUI_PORT=$QBITTORRENT_WEBUI_PORT"
echo "QBITTORRENT_WEBUI_USERNAME=$QBITTORRENT_WEBUI_USERNAME"
echo "QBITTORRENT_WEBUI_PASSWORD=$QBITTORRENT_WEBUI_PASSWORD"
echo "INITIAL_DELAY_SEC=$INITIAL_DELAY_SEC"
echo "CHECK_INTERVAL_SEC=$CHECK_INTERVAL_SEC"
echo "ERROR_INTERVAL_SEC=$ERROR_INTERVAL_SEC"
echo "ERROR_INTERVAL_COUNT=$ERROR_INTERVAL_COUNT"

qbittorrent_base_url="http://$QBITTORRENT_WEBUI_HOST:$QBITTORRENT_WEBUI_PORT"

current_port="0"
new_port=$current_port

error_count=0

echo "Waiting $INITIAL_DELAY_SEC seconds for initial delay"
sleep "$INITIAL_DELAY_SEC" &
wait $!

while true; do
  if [ $error_count -ge "$ERROR_INTERVAL_COUNT" ]; then
    echo "Reached maximum error count ($error_count), sleeping for $CHECK_INTERVAL_SEC sec"
    sleep "$CHECK_INTERVAL_SEC" &
    wait $!
    error_count=0
  fi

  echo "$(curl icanhazip.com 2>/dev/null)"
  curl icanhazip.com 2>/dev/null
  echo "Getting forwarded port"
  mapping_info=$(natpmpc -a 1 0 tcp 60 -g 10.2.0.1)
  if [[ $mapping_info =~ Mapped\ public\ port\ ([0-9]+) ]]; then
    new_port=${BASH_REMATCH[1]}
    echo "Mapped public port: $new_port"
  else
    echo "Error: Failed to extract mapped public port from natpmpc output"
    error_count=$((error_count + 1))
    sleep "$ERROR_INTERVAL_SEC" &
    wait $!
    continue
  fi

  echo "Received: $new_port"

  if [ -z "$new_port" ] || [ "$new_port" = "0" ]; then
    echo "Error: New port is empty or 0"
    error_count=$((error_count + 1))
    sleep "$ERROR_INTERVAL_SEC" &
    wait $!
    continue
  fi

  if [ "$new_port" = "$current_port" ]; then
    echo "New port is the same as current port, nothing to do"
    sleep "$CHECK_INTERVAL_SEC" &
    wait $!
    continue
  fi

  echo "Updating port"

  echo "Logging into qBittorrent WebUI"
  login_data="username=$QBITTORRENT_WEBUI_USERNAME&password=$QBITTORRENT_WEBUI_PASSWORD"
  login_url="$qbittorrent_base_url/api/v2/auth/login"
  find_cookie="/set-cookie/ {print substr(\$2, 1, length(\$2)-1)}"
  cookie=$(curl -i --data "$login_data" "$login_url" 2>/dev/null | gawk -e "$find_cookie")

  if [ -z "$cookie" ]; then
    echo "Failed to login to qBittorrent WebUI at $login_url"
    error_count=$((error_count + 1))
    sleep "$ERROR_INTERVAL_SEC" &
    wait $!
    continue
  fi

  echo "Sending new port to qBittorrent WebUI"
  set_preferences_url="$qbittorrent_base_url/api/v2/app/setPreferences"
  curl "$set_preferences_url" --cookie "$cookie" -d "json={\"listen_port\":$new_port}" 2>/dev/null

  echo "Confirming new port"
  get_preferences_url="$qbittorrent_base_url/api/v2/app/preferences"
  confirm_port=$(curl "$get_preferences_url" --cookie "$cookie" 2>/dev/null | jq .listen_port)

  echo "Logging out"
  curl -X POST "$qbittorrent_base_url"/api/v2/auth/logout --cookie "$cookie" 2>/dev/null

  if [ "$confirm_port" != "$new_port" ]; then
    echo "Errror: Failed updating port"
    error_count=$((error_count + 1))
    sleep "$ERROR_INTERVAL_SEC" &
    wait $!
    continue
  fi

  echo "Opening the new port on the firewall, and closing the old port"

  iptables_rule() {
    local verb=$1
    local port=$2
    local action

    case "$verb" in
    check) action="-C" ;;
    append) action="-A" ;;
    delete) action="-D" ;;
    *)
      echo "Error: Unknown action '$verb'" >&2
      return 1
      ;;
    esac

    iptables "$action" INPUT -i "$VPN_INTERFACE" -p tcp --dport "$port" -j ACCEPT
  }

  # Append the new rule if it doesn't already exist
  if ! iptables_rule check "$new_port" 2>/dev/null; then
    iptables_rule append "$new_port"
  fi

  # Delete the old rule if it exists
  if [ -n "$current_port" ]; then
    if iptables_rule check "$current_port" 2>/dev/null; then
      iptables_rule delete "$current_port"
    fi
  fi

  echo "Successfully updated port"

  current_port=$new_port

  sleep "$CHECK_INTERVAL_SEC" &
  wait $!
done

set +x
