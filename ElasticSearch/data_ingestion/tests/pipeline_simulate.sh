curl -X POST "localhost:9200/_ingest/pipeline/_simulate" -H 'Content-Type: application/json' -d '
{
    "pipeline" :
    {
    "description": "_description",
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
    },
    "docs": [
    {
      "_index": "index",
      "_id": "id",
      "_source": {
        "csv_line": "e12b92dbb8eaee78b22965d2a9bbbd9f,HORNBY Coach R4410A BR Hawksworth Corridor 3rd,Hornby,£39.99,,1,2,5.0 out of 5 stars,Hobbies > Model Trains & Railway Sets > Rail Vehicles > Trains,,Hornby 00 Gauge BR Hawksworth 3rd Class W 2107 W # R4410A,Technical Details Item Weight259 g Product Dimensions31.6 x 9.2 x 4.6 cm Manufacturer recommended age:3 years and up Manufacturer referenceR4410A Scaleoo Track Width/GaugeOO    Additional Information ASINB004QGOT5G Best Sellers Rank 852 720 in Toys & Games (See top 100) #1480 in Toys & Games > Model Trains & Railway Sets > Rail Vehicles > Trains Shipping Weight259 g Delivery Destinations:Visit the Delivery Destinations Help page to see where this item can be delivered. Date First Available3 Mar. 2011    Feedback  Would you like to update product info or give feedback on images?,Hornby 00 Gauge BR Hawksworth 3rd Class W 2107 W # R4410A,,,I love it // 5.0 // 22 July 2013 // By  Lilla Lukacs     on 22 July 2013 // I love it. Perfect with the earlier ordered locomotive.Again: I would recommend it to the masters of the topic. It s not just a toy.,"
      }
    }
    ]
}'
