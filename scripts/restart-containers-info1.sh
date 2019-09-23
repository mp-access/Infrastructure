docker-compose down
docker-compose pull frontend
docker-compose pull course-service
docker-compose -f docker-compose-prod.yml up -d