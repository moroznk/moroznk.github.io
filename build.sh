command -v docker-compose > /dev/null 2>&1 && DC="docker-compose" || DC="docker compose"
echo "Building site to site/_site"
$DC up builder --build --abort-on-container-exit --exit-code-from builder
