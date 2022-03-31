from lib2to3.pytree import Base
from typing import Optional
from fastapi import FastAPI, Query
from elasticsearch import Elasticsearch
from elasticsearch_dsl import Search, Q
import os

####################################################
# définition de l'adresse de l'API d'Elasticsearch
es_api_address = os.environ.get('ES_API_ADDRESS')
#es_api_address = "localhost"

# port de l'API d'Elasticsearch
es_api_port = "9200"

####################################################
es_client = Elasticsearch('http://{adress}:{port}'.format(adress=es_api_address,port=es_api_port))


app = FastAPI(title="Search API",
                description="API to search in an extract of amazon products")

####################################################
def match_range_query_build(matchers:list, rangers:list):
    try:
        q = Q({"match_all":{}})

        if (len(matchers) > 0) | (len(rangers) > 0):
            q_list = []
            for matcher in matchers:
                matcher_split = matcher.split(':')
                q_list.append(Q({"match": {"{search_key}".format(search_key=matcher_split[0]):"{search_value}".format(search_value=matcher_split[1])}}))

            for ranger in rangers:
                ranger_split = ranger.split(':')
                q_list.append(Q({"range": {"{range_key}".format(range_key=ranger_split[0]): {"{range_op}".format(range_op=ranger_split[1]):"{range_value}".format(range_value=ranger_split[2])}}}))

            if len(q_list) == 1:
                q = q_list[0]
            else:
                q = Q('bool', must=q_list)
        return q
    except BaseException as error:
        with open("api_logs.log", "a") as file:
            file.write("{error}".format(error=error))

def aggs_query_build(aggs_filters:list, agg_type:str, s):
    try:
        if len(aggs_filters) > 0:
            for agg_filters in aggs_filters:
                agg_filters_split = agg_filters.split(':')

                if (agg_type == 'agg_filter'):
                    s = s.filter(Q({"term": {"{filter_key}".format(filter_key=agg_filters_split[1]):"{filter_value}".format(filter_value=agg_filters_split[2])}}))
                elif (agg_type == 'bucket'):
                    if (len(agg_filters_split) == 3):
                            s.aggs.bucket("{title}".format(title=agg_filters_split[0]), 
                                    "{bucket_type}".format(bucket_type=agg_filters_split[1]), 
                                    field="{field_value}".format(field_value=agg_filters_split[2]))
                    elif (len(agg_filters_split) == 4):
                            s.aggs.bucket("{title}".format(title=agg_filters_split[0]), 
                                    "{bucket_type}".format(bucket_type=agg_filters_split[1]), 
                                    field="{field_value}".format(field_value=agg_filters_split[2]),
                                    interval="{interval_value}".format(interval_value=agg_filters_split[3]))
                elif (agg_type == 'metric'):
                    if (len(agg_filters_split) == 3):
                            s.aggs.metric("{title}".format(title=agg_filters_split[0]), 
                                    "{metric_type}".format(metric_type=agg_filters_split[1]), 
                                    field="{field_value}".format(field_value=agg_filters_split[2]))
        
        return s   
    except BaseException as error:
        with open("api_logs.log", "a") as file:
            file.write("{error}".format(error=error))   

@app.get('/products/status')
async def get_status():
    '''Returns api status : 1 --> api running correctly'''
    return 1

@app.get('/products')
async def get_products(matchers:list = Query([]), rangers:list = Query([])):
    '''Returns products by search criteria or all product if not'''
    try:
        s = Search(using=es_client, index="amazon_products").query(match_range_query_build(matchers, rangers))
        response = s.execute()
        return response.to_dict()
    except BaseException as error:
        with open("api_logs.log", "a") as file:
            file.write("{error}".format(error=error))

@app.get('/products/aggs')
async def get_products_aggs(aggs_filter:list = Query([]), aggs_bucket:list = Query([]), aggs_metric:list = Query([])):
    '''Returns products aggregations (type bucket or metric)'''
    try:
        s = Search(using=es_client, index="amazon_products")

        s = aggs_query_build(aggs_filter, 'agg_filter', s)
        s = aggs_query_build(aggs_bucket, 'bucket', s)
        s = aggs_query_build(aggs_metric, 'metric', s)
        
        response = s.execute()
        return response.to_dict()
    except BaseException as error:
        with open("api_logs.log", "a") as file:
            file.write("{error}".format(error=error))
