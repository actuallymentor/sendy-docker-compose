# Importing database dumps

You can export databases on your old installation by running:

```bash
YOUR_SENDY_MYSQL_USER=changeme
YOUR_SENDY_MYSQL_USER_PASSWORD=changeme123
YOUR_SENDY_DATABASE_NAME=changeme
mysqldump -u $YOUR_SENDY_USER -p$YOUR_SENDY_MYSQL_USER_PASSWORD $YOUR_SENDY_DATABASE_NAME > backup.sql
```

Note the space between `-u` and the lack of space between `-p` and the password.

You can then copy the sql file to the `database-imports` folder and run `bash scripts/provision.sh` to import the database. You can download the file through the cli with `rsync` like so:

```bash
YOUR_SERVER_IP=1.1.1.1
YOUR_USER=root
LOCATION_OF_THE_SQL_FILE=~/backup.sql
LOCATION_TO_COPY_THE_SQL_FILE_TO=~/Downloads/backup.sql
rsync -avz --progress  $YOUR_USER@$YOUR_SERVER_IP:$LOCATION_OF_THE_SQL_FILE $LOCATION_TO_COPY_THE_SQL_FILE_TO
```

You may delete the sql file after importing it.