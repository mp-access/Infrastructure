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

docker-compose exec mongo mongorestore -u $MONGO_DB_USER -p $MONGO_DB_PASSWORD $1
