#!/bin/bash

### config s3
s3_bucket="bucketname"
s3_prefix="prefix"

db_user="username"
db_pass="password"
db_host="host"
db_port="port"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
MYSQL_OPTS="--host=${db_host} --port=${db_port} --user=${db_user} --password=${db_pass}"

backup_and_compression_and_push_to_s3 () {
    for database in $(mysql ${MYSQL_OPTS} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)"); do
        backup_filename="${database}_${timestamp}.sql.gz"
        mysqldump ${MYSQL_OPTS} ${database} | gzip > "${backup_filename}"

        # upload to s3
        aws s3 cp "$backup_filename" "s3://${s3_bucket}/${s3_bucket}/${backup_filename}"
        if [ $? -eq 0 ]; then
            echo "File uploaded successfully."
        else
            echo "File upload failed!"
        fi
        echo "Backup of database ${database} created: ${backup_filename}"

        rm -f "$backup_filename"
done

}

backup_and_compression_and_push_to_s3
