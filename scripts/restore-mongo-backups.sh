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

docker exec $(docker-compose ps -q mongo) mkdir -p $1

docker cp $1 "$(docker-compose ps -q mongo)":$1

echo "Restoring db $1access/"
echo "Restoring db $1admin/"
docker-compose exec mongo mongorestore -u $MONGO_DB_USER -p $MONGO_DB_PASSWORD $1access/
docker-compose exec mongo mongorestore -u $MONGO_DB_USER -p $MONGO_DB_PASSWORD $1admin/

docker-compose exec mongo rm -rf $1
