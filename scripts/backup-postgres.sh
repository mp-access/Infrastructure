
if [ "$#" -ne 2 ]; then
    echo "[Usage]: backup-postgres.sh <backup filename> <path to backup folder>"
    exit 1
fi

printf "$(date -u)\t%s\n" "Running postgres backup script"

DUMP_FILE="$1-`date +%Y-%m-%d"_"%H_%M_%S`.sql"
FULL_PATH=$2/$DUMP_FILE
TMP_FILE="/tmp/$DUMP_FILE"

printf "$(date -u)\t%s\n" "Will save backup to $FULL_PATH"

# Read DB_USER env variable and password
export $(cat .env | grep "^DB_USER=")
export $(cat .env | grep "^DB_PASSWORD=")

printf "$(date -u)\t%s\n" "Generating backup. Connecting as user $MONGO_DB_USER"

# Generate dump and put it into /tmp/dump.sql
/usr/local/bin/docker-compose exec -T postgres pg_dumpall -U $DB_USER --clean -f $TMP_FILE

printf "$(date -u)\t%s\n" "Setting correct user permissions"

# Set permissions to read outside of container
/usr/local/bin/docker-compose exec -T postgres chmod ug+rx $TMP_FILE

printf "$(date -u)\t%s\n" "Copy backup outside of container"

docker cp "$(/usr/local/bin/docker-compose ps -q postgres)":$TMP_FILE $FULL_PATH

printf "$(date -u)\t%s\n" "Cleanup"

# Remove backup inside container
/usr/local/bin/docker-compose exec -T postgres rm -rf $TMP_FILE

printf "$(date -u)\t%s\n" "Done"