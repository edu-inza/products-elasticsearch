FROM ubuntu:latest
ADD requirements.txt search_api.py ./
RUN apt-get update && apt-get install python3-pip -y && pip install -r requirements.txt
ENV ES_API_ADDRESS=es_amazon_products
EXPOSE 8000
CMD uvicorn search_api:app --host 0.0.0.0