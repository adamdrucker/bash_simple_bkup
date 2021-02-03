#!/bin/bash

# Cron job set to run this script weekly on Tuesdays @ 12:00
# and on Thursdays @ 12:00
# Currently, being manually backed up to Google Drive
# --> Can now use `gupload` (Jan 2021)

# Init date
TODAY=$(date +%d-%m-%Y)

# Init backup directory
BACKUPDIR="/home/$USER/Backups"

# Count items in backup directory
COUNT=$(ls $BACKUPDIR -t | wc -l)


back_up_files() {
	tar -zc -X /home/adam/Documents/bash_scripts/simple_bkup/exclude.txt -f /home/$USER/Backups/"$TODAY"_backup.tar.gz /home/$USER /etc/passwd 
}

# Removed from above `/home/$USER/Documents /home/$USER/.bashrc` && /home/$USER/Documents /home/$USER/.bashrc /home/$USER/.google* /home/$USER/.ssh /home/$USER/.vimrc /home/$USER/.bash_aliases /    home/$USER/.apps

back_up_dir() {
	if [ $COUNT -gt "4" ]; then
		cd $BACKUPDIR
		ls -t $BACKUPDIR | tail -n +5 | xargs rm -f
		cd ~
		# tar -czvf /home/$USER/Backups.tar.gz /home/$USER/Backups 2>/dev/null
	fi
}

test -d $BACKUPDIR
if [ $? == "1" ]; then
	mkdir "/home/$USER/Backups"
fi

#---------------------------------
echo "Starting backup for $(date +%A) $(date +%d-%b-%Y)..."

back_up_files

if [ $? == "0" ]; then
	echo "File backup successful."
	echo "Starting upload to Google Drive..."
	gupload /home/$USER/Backups/"$TODAY"_backup.tar.gz
	if [ $? == "0" ]; then
		echo "GUpload successful."
	else
		echo "GUpload failed."
	fi
else
	echo "File backup failed, please review."
fi

back_up_dir

if [ $? == "0" ]; then
	echo "Directory cleanup successful."
else
	echo "Directory cleanup failed, please review."
fi
