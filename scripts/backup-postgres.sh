if [ "$#" -ne 2 ]; then
    echo "[Usage]: backup-postgres.sh <backup filename> <path to backup folder>"
    exit 1
fi

DUMP_FILE=$1
BACKUP_PARTITION=$2
FULL_PATH=$2/$1

# Read DB_USER env variable and password
export $(cat .env | grep "^DB_USER=")
export $(cat .env | grep "^DB_PASSWORD=")

# Generate dump and put it into /tmp/dump.sql
docker-compose exec postgres pg_dumpall -U $DB_USER --clean > "$FULL_PATH-`date +%Y-%m-%d"_"%H_%M_%S`.sql"

# Set permissions to read outside of container
#chown 1005:100 $FULL_PATH
