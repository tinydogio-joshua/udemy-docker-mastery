# Setup Networks
docker network create --driver overlay backend
docker network create --driver overlay frontend

# Setup Volumes
docker volume create db-data

# Voting App
docker service create -p 80:80 --network frontend --replicas 2 --name vote bretfisher/examplevotingapp_vote

# Redis Cache
docker service create --network frontend --replicas 1 --name redis redis:3.2

# Postgres Database
docker service create --network backend --replicas 1 -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data --name db postgres:9.4

# Worker Process
docker service create --network backend --network frontend --replicas 1 --name worker bretfisher/examplevotingapp_worker

# Reults Dashboard
docker service create -p 5001:80 --network backend --replicas 1 --name result bretfisher/examplevotingapp_result

