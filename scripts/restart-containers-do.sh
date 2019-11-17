docker pull hoal/frontend:dev
docker pull hoal/course-service:dev

docker-compose -f docker-compose-tag.yml -f docker-compose.analytics.yml up -d