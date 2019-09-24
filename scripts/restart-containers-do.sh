docker-compose down
docker pull hoal/frontend:dev
docker pull hoal/course-service:dev
docker-compose -f docker-compose-do.yml up -d