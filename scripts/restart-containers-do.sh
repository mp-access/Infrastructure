docker pull hoal/frontend:dev
docker pull hoal/course-service:dev
docker pull hoal/analytics-backend:master
docker pull hoal/analytics-frontend:master

docker-compose -f docker-compose.yml -f docker-compose.analytics.yml up -d
