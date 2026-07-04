command -v docker-compose > /dev/null 2>&1 && DC="docker-compose" || DC="docker compose"
echo "Running on http://localhost:4000 (develop mode)"
$DC rm -f
$DC up site --build --force-recreate
