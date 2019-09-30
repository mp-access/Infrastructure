
if [ "$#" -ne 2 ]; then
    echo "[Usage]: backup-postgres.sh <backup filename> <path to backup folder>"
    exit 1
fi

echo "$(date -u) Running mongodb backup script"

DUMP_FILE="$1-`date +%Y-%m-%d"_"%H_%M_%S`"
FULL_PATH=$2/$DUMP_FILE
TMP_FILE="/tmp/$DUMP_FILE"
BACKUP_PARTITION=$2

echo "$(date -u) Will save backup to $FULL_PATH"

# Read DB_USER env variable and password
export $(cat .env | grep "^MONGO_DB_USER=")
export $(cat .env | grep "^MONGO_DB_PASSWORD=")

echo "$(date -u) Generating backup. Connecting as user $MONGO_DB_USER"

# Generate dump and put it into /tmp/dump.sql
/usr/local/bin/docker-compose exec -T mongo mongodump -u $MONGO_DB_USER -p $MONGO_DB_PASSWORD --out $TMP_FILE

echo "$(date -u) Setting correct user permissions"

# Set permissions to read outside of container
/usr/local/bin/docker-compose exec -T mongo chmod ug+rx $TMP_FILE

echo "$(date -u) Copy backup outside of container"

docker cp "$(/usr/local/bin/docker-compose ps -q mongo)":$TMP_FILE $FULL_PATH

echo "$(date -u) Cleanup"

# Remove backup inside container
/usr/local/bin/docker-compose exec -T mongo rm -rf $TMP_FILE

echo "$(date -u) Done"