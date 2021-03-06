#! /bin/bash

source rtb.config

# Some requirements
## Screen
## zip (command line)

# Config section in rtb.config. This file can not be replace with lates versions
# without you having to redo all the config stuff

echo $server_start
function ftbmon() {
#  server_stop
#  kill $(ps faux | grep inotifywait | grep $server_path | awk '{print $2}')
  sleep 55
  while [[ 1 ]]
   do
    server_check
    sleep 5
#    epoch_time=$(date +%s)
#    last_backup="$(stat -c %X $(find ${backup_location} -type f -mtime -1 -iname "backup*.zip"|grep $(date +%b)|sort|tail -n 1) 2>/dev/null)"
 #   [[ -z $last_backup ]] && last_backup=1 ## 1 second epoch time to force a backup if none exists.
 #   backup_time_diff=$(($epoch_time - $last_backup))
#    if [[ $backup_time_diff -gt $backup_interval ]]
#    then
#      [[ ! -d $backup_location ]] && mkdir -p $backup_location
#      echo -e "$(date) -- \e[1;32mCreating a server backup:\e[0;32m Time since last backup: $backup_time_diff seconds ($(($backup_time_diff/60)) minutes) ($(($backup_time_diff/60/60)) hours)\e[0m"
#      backup_file="${backup_location}/backup-$(date +%H-%M-%S_%d-%b-%Y).zip"
#      zip -r "${backup_file}" "${server_path}" &> /dev/null
#      echo -e "$(date) -- \e[0;32mBacked Up Server files to\e[1;32m ${backup_file} \e[0m"
#      find ${backup_location} -type f -name "backup-*.zip" -mtime +${backup_retention} -exec rm -fv "{}" \;
#    fi
#    if [[ $use_extended_options = 1 ]]
#     then extended_backup
#    fi
  done
}

function server_check() {
  if [[ "$(cat test.cmd | netcat 127.0.0.1 25565)"  == "" ]]; then
    log "Server port not responding", "Attempting to restart."
    server_restart
  fi
  sleep 55
}

function extended_backup() {
  sleep 1 # Doesn't do anything yet.
}

function server_restart() {
  server_stop
  sleep 5
  server_go
}
function server_stop() {
  pid="$(ps faux | grep "${server_start}" | grep -i screen | awk '{print $2}')"
  #SIGTERM - it's nicer and lets our server try to save
  kill pid
  sleep 10 #give it time to die with honor
  #still not dead? then nuke it.
  kill -9 pid
}
function server_go() {
  screen -S "FTB-Server" -d -m -c /dev/null -- bash -c "$server_start;exec $SHELL"
}

function log() {
  echo "$(date) -- $1 | $2" >> $crashlog
  echo "" >> $crashlog
}


ftbmon &
screen -S "FTB-Server" -d -m -c /dev/null -- bash -c "$server_start;exec $SHELL"
