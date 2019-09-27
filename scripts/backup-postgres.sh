
if [ "$#" -ne 2 ]; then
    echo "[Usage]: backup-postgres.sh <backup filename> <path to backup folder>"
    exit 1
fi

DUMP_FILE="$1-`date +%Y-%m-%d"_"%H_%M_%S`.sql"
FULL_PATH=$2/$DUMP_FILE
TMP_FILE="/tmp/$DUMP_FILE"
BACKUP_PARTITION=$2

# Read DB_USER env variable and password
export $(cat .env | grep "^DB_USER=")
export $(cat .env | grep "^DB_PASSWORD=")

# Generate dump and put it into /tmp/dump.sql
docker-compose exec postgres pg_dumpall -U $DB_USER --clean -f $TMP_FILE

# Set permissions to read outside of container
docker-compose exec postgres chmod ug+rx $TMP_FILE

docker cp "$(docker-compose ps -q postgres)":$TMP_FILE $FULL_PATH

# Remove backup inside container
docker-compose exec postgres rm -rf $TMP_FILE