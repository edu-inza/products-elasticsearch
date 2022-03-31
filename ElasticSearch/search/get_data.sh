## recherche de tous les éléments
curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
{
   "query":{
       "match_all":{}
   }
}' 

## recherche dans une fourchette de prix
# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#         "range":{
#             "price":{
#                 "gte":0,
#                 "lte":20
#             }
#         }
#     }
# }'

## nombre de produits par intervalle de prix de 20
# curl -X POST 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "aggs":{
#         "prices":{
#             "histogram":{
#                 "field":"price",
#                 "interval":20
#             }
#         }
#     }
# }'

## recherche dans une catégorie ou sous-catégorie
# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#         "match":{
#             "categories": "Hobbies"
#         }
#     }
# }'

# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#         "match":{
#             "categories": "Rail"
#         }
#     }
# }'
## 0 résultat car on utilise un analyzer type "keyword" sur le nom complet de la catégorie/sous-catégorie

# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#         "match":{
#             "categories": "Rail Vehicles"
#         }
#     }
# }'

## recherche par marque
# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#         "match":{
#             "manufacturer": "Hornby"
#         }
#     }
# }'

## recherche par libellé
# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#        "match":{
#            "product_name": "Loco" 
#        }
#     }
# }'
## on obtient les résultats des synonymes de l'analyzer

# curl -X GET 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "query":{
#        "match":{
#            "product_name": "trains" 
#        }
#     }
# }'
## on obtient les singuliers et les pluriels grâce à l'analyzer de langue

## recherche des trains dont la note est supérieur à 4.5, avec un prix inférieur à 50£
# curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d '
# {
#   "query": { 
#     "bool": { 
#       "must": [
#         { "match":{"product_name": "trains"}}
#       ],
#       "filter": [ 
#         { "range":  {"average_review_rating": {"gte": "4.5"}}},
#         { "range": {"price": {"lte": "50"}}}
#       ]
#     }
#   }
# }'

## recherche du prix moyen et des intervals de prix pour les produits de la catégorie "Lamps & Lighting"
# curl -X POST 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {
#     "aggs":{
#         "price_for_lamps":{
#             "filter": { "term": { "categories": "lamps and lighting"}},
#             "aggs":{
#                 "avg_price": {"avg": {"field": "price"}},
#                 "prices":{
#                     "histogram":{
#                         "field":"price",
#                         "interval":20
#                     }
#                  }
#             }
        
#         }
#     }
# }'



# curl -X POST 'localhost:9200/amazon_products/_search?pretty' -H 'Content-Type: application/json' -d '
# {"query": 
# 	{"bool": 
# 		{"filter": 
# 			[{"term": {"categories": "lamps and lighting"}}]
# 		}
# 	}, 
# 	"aggs": 
# 	{
# 		"prices": {"histogram": {"field": "price", "interval": "20"}}, 
# 		"avg_price": {"avg": {"field": "price"}}
# 	}
# }'