USERNAME=$1
PASSWORD=$2
DB=$3

echo "$(date -u) Creating read only user $USERNAME for database $DB"

# Read DB_USER env variable and password
export $(cat .env | grep "^MONGO_DB_USER=")
export $(cat .env | grep "^MONGO_DB_PASSWORD=")

# Generate dump and put it into /tmp/dump.sql
echo "db.createUser({user: \"$USERNAME\", pwd: \"$PASSWORD\", roles: [{role: \"read\", db: \"$DB\"}]})" | /usr/local/bin/docker-compose exec -T mongo mongo -u "$MONGO_DB_USER" -p "$MONGO_DB_PASSWORD" --authenticationDatabase admin admin

echo "$(date -u) Created user $USERNAME"
