# products-elasticsearch
L'échantillon de données utilisé est issue d'un web scraping d'un site ecommerce. L'échantillon est limité à 200 produits.

Le code est réparti en 2 parties :
- la création et l'ingestion de données dans un elasticsearch
- une API pour les recherches de données dans elasticsearch. L'API est containerisé dans un docker.

# Installation
Pour utiliser la solution, lancer le script `setup.sh`à la racine.
Ce script permet de lancer :
1. un docker-compose avec 2 containers : un pour la base elasticsearch et un autre pour l'API de recherche.
2. un script pour la création de l'index et l'ingestion des données dans elasticsearch

# API
L'API expose 3 endpoints :
- GET /products/status : permet de vérifier le bon fonctionnement de l'API
- GET /products : permet de réaliser des requêtes de type query DSL. Ce endpoint prend des query parameters pour construire la query DSL.
Les query parameters sont :
    -  matchers : construit une requête de type `match`. Format du query parameter : matchers=*field*:*value*
       
    -  rangers : construit une requête de type `range`. Format du query parameter : rangers=*field*:*operator*:*value*

    >exemples : 
    >
    >?matchers=categories:Rail Vehicles
    >
    >?matchers=manufacturer:Hornby&matchers=categories:Rail Vehicles
    >
    >?matchers=product_name:trains&rangers=average_review_rating:gte:4.5&rangers=price:lte:50

- GET /products/aggs : permet de réaliser des requêtes d'aggrégations. Ce endpoint prend des query parameters pour construire la requête d'aggrégation.
Les query parameters sont :
    - aggs_filter: construit une requête d'aggrégation avec des filtres. Format du query parameter : aggs_filter=*filter_title*:*field*:*value*

    - aggs_bucket: construit une requête d'aggrégation de type bucket. Format du query parameter : aggs_bucket=*bucket_title*:*bucket_type*:*field*:*interval if histogram (optional)*

    - aggs_metric: construit une requête d'aggrégation de type metric. Format du query parameter : aggs_metric=*metric_title*:*metric_type*:*field*

    >exemples : 
    >
    >?aggs_bucket=prices:histogram:price:20&aggs_metric=avg_price:avg:price
    >
    >?aggs_filter=price_for_lamps:categories:lamps and lighting&aggs_bucket=prices:histogram:price:20&aggs_metric=avg_price:avg:price
    >
    >?aggs_filter=price_for_lamps:categories:lamps and lighting&aggs_metric=avg_price:avg:price&aggs_metric=min_price:min:price&aggs_metric=max_price:max:price

Pour des exemples d'appel à l'API, se référer au `TU_search_api.py` dans le dossier `/API/TU`.

# Elasticsearch
Pour plus d'information, se référer au README.md dans le dossier `ElasticSearch`