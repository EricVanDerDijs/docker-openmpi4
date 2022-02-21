#!/bin/bash

touch machines
HEAD_ID=$(docker ps -f "ancestor=docker-openmpi4_node" -f "name=head" -q)

# Get container ids
docker ps -f "ancestor=docker-openmpi4_node" -q | \
# Get internal ip of those containers by mapping output to docker inspect command
xargs -I % bash -c "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' %" | \
# Format output to match openmpi hostfile format and save it to machines file
xargs -I % bash -c "echo '% slots=1'" > machines

echo "hostfile content:"
cat ./machines
echo "Copying hostfile to HEAD container..."
docker cp ./machines $HEAD_ID:/home/tutorial/src/machines
rm ./machines