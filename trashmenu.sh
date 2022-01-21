#! /usr/bin/env bash
# dmenu trash

# print
function main_menu {
  printf "Trash Empty\n"
  printf "Trash List\n"
  printf "Trash Restore\n"
}

function prefix {
  total_size="$(du -sh ~/.local/share/Trash/files | awk '{ print $1 }')"
  total_files="$(gio trash --list | wc -l)"
  printf "[%s]" "$total_size - $total_files"
}

print_prefix=$(prefix)

option=$(main_menu | dmenu -fn "Iosevka" -h 25 -X 5 -Y 5 -nb "#101010" -nf "#808080" -sb "#000000" -sf "#600000" -p "Trash Options $print_prefix: ")

# cases here
if [ -n "$option" ]; then
  case $option in
    "Trash Empty")
      gio trash --empty
      polybar-msg hook info-trash 1 && notify-send -i trash-empty "Trash" "Trash Emptied"
      ;;
    "Trash List")
      gio trash --list | awk '{print $1}' | dmenu -l 15 -fn "Iosevka" -h 25 -X 5 -Y 5 -nb "#101010" -nf "#808080" -sb "#000000" -sf "#600000" -p "Files In Trash $print_prefix"
      ;;
    "Trash Restore")
      restore_file="$(gio trash --list | awk '{print $1}' | dmenu -l 15 -fn "Iosevka" -h 25 -X 5 -Y 5 -nb "#101010" -nf "#808080" -sb "#000000" -sf "#600000" -p "Restore Trash Files $print_prefix: ")"

      if [ -n "$restore_file" ]; then
        gio trash --restore "$restore_file"
        polybar-msg hook info-trash 1 && notify-send -i trash "Trash" "Files Restored"
      fi
      ;;
    *)
      notify-send "No Option Selected"
      ;;
  esac
fi
