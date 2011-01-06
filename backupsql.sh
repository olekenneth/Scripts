#!/bin/bash

# Written by Ole Fredrik Skudsvik.
# 03/08/2010

################################################################################
#                          Configuration parameters.                           #                                                    
################################################################################

MYSQL_HOST="localhost"
MYSQL_USER="root"
MYSQL_PASS=""
IGNORE_DATABASES=(mysql) # Separate entries with space.

BACKUPDIR="/root/sql" # This directory must exist before you run the script.
DATETAG=`date "+%m%d%Y"` # Do not change this unless you know the date format.

################################################################################

if [ ! -d ${BACKUPDIR} ]; then
echo "${BACKUPDIR} does not exist. Create it!"
exit
fi

for db in `mysql -h ${MYSQL_HOST} -u ${MYSQL_USER}  -p${MYSQL_PASS} -B -s -e "SHOW DATABASES;"`
do 
donotbackup=0

for dbname in ${IGNORE_DATABASES[@]}
do
if [ "$db" == "$dbname" ]; then
donotbackup=1
break
fi
done

if [ $donotbackup -eq 1 ];  then
echo "Ignoring $dbname"
continue
fi

echo "Backing up ${db}..."
mysqldump -h ${MYSQL_HOST} -u ${MYSQL_USER}  -p${MYSQL_PASS} ${db} | gzip > "${BACKUPDIR}/${db}_${DATETAG}.sql.gz"
done
