# delete data
$PWD/data_ingestion/delete_data.sh

# delete index
curl -X DELETE localhost:9200/amazon_products 

# delete pipeline
curl -X DELETE localhost:9200/_ingest/pipeline/pipeline_amazon_products