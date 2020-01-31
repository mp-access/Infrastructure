set -ex
docker exec $(docker-compose ps -q keycloak) /opt/jboss/keycloak/bin/add-user-keycloak.sh -u admin -p "123456"
docker-compose restart keycloak