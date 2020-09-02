docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$(docker-compose -f docker-compose.yml ps -q keycloak)"
