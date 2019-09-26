docker pull hoal/frontend:dev
docker pull hoal/course-service:dev

docker-compose down
docker-compose -f docker-compose-do.yml up -d