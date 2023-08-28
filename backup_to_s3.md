Script backup postgresql database using barman backup and push to AWS S3 storage

How to use?
Download file
  wget https://raw.githubusercontent.com/nguyenlinh1999/Bash-Script/main/backup_to_s3.sh
Set permission
  chown barman:barman backup_to_s3.sh
  chmod u+x backup_to_s3.sh
Run script
  bash backup_to_s3.sh PG_SERVER PG_VERSION
### Replace with your PG_SERVER and PG_VERSION 
