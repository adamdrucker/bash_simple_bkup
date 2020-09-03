#!/bin/bash

# Cron job set to run this script weekly on Tuesdays @ 12:00
# and on Thursdays @ 12:00
# Currently, being manually backed up to Google Drive

# Init date
TODAY=$(date +%d-%m-%Y)

# Init backup directory
BACKUPDIR="/home/$USER/Backups"

# Count items in backup directory
COUNT=$(ls $BACKUPDIR -t | wc -l)


back_up_files() {
	tar -zcf /home/$USER/Backups/"$TODAY"_backup.tar.gz /home/$USER/Documents /home/$USER/.bashrc /etc/passwd 2>/dev/null 
}


back_up_dir() {
	if [ $COUNT -gt "4" ]; then
		cd $BACKUPDIR
		ls -t $BACKUPDIR | tail -n +5 | xargs rm -f
		cd ~
		tar -czvf /home/$USER/Backups.tar.gz /home/$USER/Backups 2>/dev/null
	fi
}

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

back_up_files

if [ $? == "0" ]; then
	echo "File backup successful."
else
	echo "File backup failed, please review."
fi

back_up_dir

if [ $? == "0" ]; then
	echo "Directory backup successful."
else
	echo "Directory backup failed, please review."
fi
