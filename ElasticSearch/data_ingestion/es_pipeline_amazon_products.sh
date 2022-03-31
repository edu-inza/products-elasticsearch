curl -X PUT localhost:9200/_ingest/pipeline/pipeline_amazon_products -H "Content-Type: application/json" -d '{
    "processors": [
        {
            "csv": {
                "field": "csv_line",
                "target_fields": ["uniq_id", "product_name", "manufacturer", "price", "number_available_in_stock","number_of_reviews", "number_of_answered_questions", "average_review_rating", "amazon_category_and_sub_category", "customers_who_bought_this_item_also_bought", "description", "product_information", "product_description", "items_customers_buy_after_viewing_this_item", "customer_questions_and_answers", "customer_reviews", "sellers"]
            }
        },
        {
            "trim": {
                "field": "uniq_id"
            }
        },
        {
            "gsub": {
                "field": "price",
                "pattern": "£",
                "replacement": ""
            }
        },
        {
            "gsub": {
                "field": "average_review_rating",
                "pattern": " out of 5 stars",
                "replacement": ""
            }
        },
        {
            "split": {
                "field": "amazon_category_and_sub_category",
                "separator": ">"
            }
        },
        {
            "foreach": {
                "field": "amazon_category_and_sub_category",
                "processor": {
                    "trim": {
                        "field": "_ingest._value"
                    }
                }
            }
        },
        {
            "rename": {
                "field": "amazon_category_and_sub_category",
                "target_field": "categories"
            }
        },
        {
            "grok": {
                "field": "number_available_in_stock",
                "patterns": ["%{NUMBER:stock.count} %{WORD:stock.type_product}"],
                "ignore_missing": true
            }
        },
        {
            "remove": {
                "field": ["number_of_reviews", "number_of_answered_questions", "customers_who_bought_this_item_also_bought", "product_description", "items_customers_buy_after_viewing_this_item", "customer_questions_and_answers", "customer_reviews", "sellers"]
            }
        }
    ]
}'