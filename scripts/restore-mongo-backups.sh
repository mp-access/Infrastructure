if [ "$#" -ne 1 ]; then
    echo "[Usage]: restore-mongo-backups.sh <backup filename>"
    exit 1
fi

read -p "Are you sure you want to restore mongodb from backup? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# Read DB_USER env variable and password
export $(cat .env | grep "^MONGO_DB_USER=")
export $(cat .env | grep "^MONGO_DB_PASSWORD=")

MONGO_CONTAINER=$(docker-compose ps -q mongo)

docker exec $MONGO_CONTAINER mkdir -p $1

docker cp $1. $MONGO_CONTAINER:$1

docker exec $MONGO_CONTAINER ls -l $1

docker-compose exec mongo mongorestore -u $MONGO_DB_USER -p $MONGO_DB_PASSWORD $1

docker-compose exec mongo rm -rf $1
