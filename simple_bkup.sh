#!/bin/bash

# Cron job set to run this script weekly on Tuesdays @ 15:00
# and on Thursdays @ 17:00
# Currently, being manually backed up to Google Drive

# Init date
TODAY=$(date +%d-%m-%Y)

# Init backup directory
BACKUPDIR="/home/$USER/Backups"

test -d $BACKUPDIR
if [ $? == "1" ]; then
	mkdir "/home/$USER/Backups"
fi


# Perform backup of user Documents
# and /etc/passwd
#---------------------------------
echo "Starting backup for $(date +%A) $(date +%d-%b-%Y)..."
echo "Backup includes:"
sleep 1s
echo "/home/$USER/Documents"
sleep 1s
echo "/home/$USER/.bashrc"
sleep 1s
echo "/etc/passwd"

tar -zcf /home/$USER/Backups/"$TODAY"_backup.tar.gz /home/$USER/Documents /home/$USER/.bashrc /etc/passwd 2>/dev/null 

if [ $? == "0" ]; then
	echo "Backup successful."
else
	echo "Backup failed, please review."
fi
