curl -X POST 'localhost:9200/amazon_products/_delete_by_query' -H 'Content-Type: application/json' -d '
{
    "query":{
        "match_all":{}
    }
}'