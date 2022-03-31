i=1
sp="/-\|"
echo -n ' '

while read f1
do
   printf "\b${sp:i++%${#sp}:1}"
   f1=$( echo "$f1" | tr -d "\n")
   curl -s -X POST "localhost:9200/amazon_products/_doc" -H "Content-Type: application/json" -d "{ \"csv_line\": \"$f1\" }" > $PWD/data_ingestion/insert_data_logs.html
done < $PWD/data/preprocessed_data.csv