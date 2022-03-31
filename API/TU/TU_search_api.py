import requests

def TU_status(expected_result:int):
    r = requests.get(url='http://127.0.0.1:8000/products/status')

    if r.status_code == expected_result:
        test_result = "OK"
    else:
        test_result = "KO"
    
    print(test_result)

def TU_search_all_products(expected_result:int):
    r = requests.get(url='http://127.0.0.1:8000/products')

    if r.status_code == expected_result:
        test_result = "OK"
    else:
        test_result = "KO"
    
    print(test_result)
    print(r.text)

def TU_search_products(expected_result:int, search_criteria:str, aggs:bool = False):
    if (not aggs):
        r = requests.get(url='http://127.0.0.1:8000/products?{search_criteria}'.format(search_criteria=search_criteria))
    else :
        r = requests.get(url='http://127.0.0.1:8000/products/aggs?{search_criteria}'.format(search_criteria=search_criteria))

    if r.status_code == expected_result:
        test_result = "OK"
    else:
        test_result = "KO"
    
    print(test_result)
    print(r.text)

# TESTS
#TU_status(200)

# Query DSL
TU_search_all_products(200)
#TU_search_products(200,matchers=categories:Rail Vehicles)
#TU_search_products(200, 'matchers=manufacturer:Hornby')
#TU_search_products(200, 'matchers=manufacturer:Hornby&matchers=categories:Rail Vehicles')
#TU_search_products(200, 'matchers=product_name:trains&rangers=average_review_rating:gte:4.5&rangers=price:lte:50')

#Agrégations
#TU_search_products(200, 'aggs_bucket=prices:histogram:price:20', True)
#TU_search_products(200, 'aggs_bucket=prices:histogram:price:20&aggs_metric=avg_price:avg:price', True)
#TU_search_products(200, 'aggs_filter=price_for_lamps:categories:lamps and lighting&aggs_bucket=prices:histogram:price:20&aggs_metric=avg_price:avg:price', True)
#TU_search_products(200, 'aggs_filter=price_for_lamps:categories:lamps and lighting&aggs_metric=avg_price:avg:price&aggs_metric=min_price:min:price&aggs_metric=max_price:max:price', True)
