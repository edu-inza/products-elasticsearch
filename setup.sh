# create and run containers
docker-compose up -d

# ingest data in elasticsearch
cd $PWD/ElasticSearch
./setup.sh
