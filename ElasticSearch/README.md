# 1. Introduction
Le jeux de données choisi pour cet exercice est 'Products on Amazon.com'.
Pour des raisons de simplicité d'installation, la version d'ElasticSearch utilisé pour l'exercice est 7.10.1.

# 2. Pré-requis : nettoyage des données
Pour intégrer les données du fichier `amazon_co-ecommerce_sample.csv`, il est nécessaire de retravailler les données. Ce nettoyage s'est fait en 2 étapes :
- une 1ere pour supprimer les virgules dans les champs du csv. Pour des raisons de simplicité, cette étape a été réalisée avec MS Excel. Le résultat de cette étape est le fichier `clean_data.csv`
- une 2e pour supprimer/remplacer tous les caractères (comme les quotes, guillements, caractères spéciaux, caractères UTF-8, etc.) ne permettant pas une intégration des données correcte dans ElasticSearch. Cette étape est traitée par le script `preprocessing_data.sh` du dossier `data_ingestion`.


# 3. Ingestion des données
L'insertion des données est séparée en 2 parties:
- la création d'éléments ElasticSearch pour l'ingestion, le stockage et le traitement de la recherche des données.
- l'insertion des données dans la base de données ElasticSearch à partir du fichier csv nettoyé.

Les scripts, fichiers de configuration, fichiers de tests relatifs à l'ingestion des données se trouve dans le dossier `data_ingestion`.

## 3.1 Elements ElasticSearch
### Création pipeline ingest node
Pour ingérer les données, une pipeline est créé avec les processors suivants :
- csv : intégration et formatage des données à partir d'un fichier csv
- trim : suppression des espaces dans le champ `unique_id`
- gsub : dans le champ `price`, suppression du caractère '£'
- split : séparation des valeurs dans le champ `mazon_category_and_sub_category`
- foreach : pour chaque valeur du tableau résultat du split précédent, suppression des espaces
- rename : renommage de la colonne `amazon_category_and_sub_category`
- grok : création de nouveaux champs sur le stock et le type de produit, suivant un template sur le champ `number_available_in_stock`
- remove : suppression des champs peu importants

### Analyzer
2 analyzers ont été créés :
- `custom_std_english`: analyse textuelle en anglais avec prise en compte d'un dictionnaire de synonymes
- `cat_subcat` : recherche par clé sur une étiquette complète, en transformant les '&' par des 'and'. Cet analyzer sera utilisé dans la recherche de catégorie/sous-catégorie

### Mapping
Les champs de type 'text' utilisent l'analyzer `custom_std_english`, à l'exception du champ `catégories` (cf analyzer).
Le champ `unique_id` est défini comme 'keyword' car il représente un id unique.
Les champs `price` et `average_review_rating` sont de type 'double'.

Les champs non indiqués dans le mapping auront un mapping dynamique défini par ElasticSearch à l'intégration des données.

### Création index
L'index utilisé pour stocker les produits amazon est 'amazon_products'.

Le fichier `amazon_products_search.json` contient la configuration pour la création de cet index.

## 3.2 Insertion données
Le script `insert_amazon_products.sh` insère les données dans l'index ElasticSearch. Pour cela, il lit chaque ligne du fichier csv et les insère dans l'index 'amazon_products'.

# 4. Recherches
Le fichier `get_data.sh` dans le dossier `search` contient plusieurs requêtes pour interroger les données.

# 5. Exécution
## 5.1 setup.sh
Le fichier `setup.sh`, à la racine, permet de réaliser toutes les tâches pour nettoyer les données, créer les éléments ElasticSearch et ingérer les données.

## 5.2 clean.sh
Le fichier `clean.sh` permet de supprimer les données, l'index et la pipeline créés précédemment. Ceci permet de relancer une nouvelle création d'index 'amazon_products' de manière propre.