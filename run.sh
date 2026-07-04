echo "Running on http://localhost:4000 (develop mode)"
docker-compose rm -f
docker-compose up site --build --force-recreate
