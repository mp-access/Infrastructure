if [ "$#" -ne 1 ]; then
    echo "[Usage]: restore-backups.sh <backup filename>"
    exit 1
fi

read -p "Are you sure you want to restore from the backup? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# Read DB_USER env variable and password
export $(cat .env | grep "^DB_USER=")
export $(cat .env | grep "^DB_PASSWORD=")

cat $1 | docker-compose exec -T postgres psql -U $DB_USER
