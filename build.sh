echo "Building site to site/_site"
docker-compose up builder --build --abort-on-container-exit --exit-code-from builder
