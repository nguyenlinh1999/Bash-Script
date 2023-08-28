# Configuration
backup_path="/var/lib/barman/"
s3_bucket="tmvn-backup-storage-dev"
s3_prefix="tmvn-db"
pg_server=$1
pg_version=$2
backup_filename="${pg_server}_${timestamp}.tar.gz"

backup_and_compression_and_push_to_s3 () {
    #Barman backup
    export PATH=$PATH:/usr/pgsql-${pg_version}/bin
    barman backup "$pg_server" > /var/log/barman/${pg_server}.log 2>&1

    echo "Completed backup =========>"
    echo "Continue tar and push to AWS S3 in 5 seconds  =========>"

    sleep 5

    ### Compression
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    tar -I pxz -cvf "$backup_filename" -C "$backup_path" "$pg_server"
    echo "Completed tar data"

    ### Upload to S3
    aws s3 cp "$backup_filename" "s3://${s3_bucket}/${s3_prefix}/${backup_filename}"
    if [ $? -eq 0 ]; then
        echo "File uploaded successfully."
    else
        echo "File upload failed!"
    fi

    # Clean up the local backup file
    rm "$backup_filename"
}

backup_and_compression_and_push_to_s3 "$pg_server" "$pg_version"
