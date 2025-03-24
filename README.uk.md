# Проект Lakehouse з використанням Docker Compose

[![en](https://img.shields.io/badge/lang-en-red.svg)](/README.md)
[![en](https://img.shields.io/badge/lang-uk-greeb.svg)](/README.uk.md) 

Цей проект грунтується на [статті](https://blog.min.io/uncover-data-lake-nessie-dremio-iceberg/) про використання Lakehouse за допомогою Open-Source сервісів  Nessie, MongoDB, Minio та Dremio.

## Початок роботи: 
- Для запуску проету потрібно встановити [Docker Compose](https://docs.docker.com/compose/install/)
- Створити файли секретів ```./secrets/minio_user``` та ```./secrets/minio_password``` та додати бажаний логін та пароль для авторизації в MINIO
- Стоврити ```.env``` на основі ```.env.example```


## Запуск проекту

Для запуску проекту виконай наступну команду:

```sh
docker-compose up -d
```

## Зупинка проекту
Для зупинки та видалення контейнерів виконай:

```sh
docker-compose down
```


## Налаштуання 
- Зачекай хвилину, а потім перейдіть за адресою http://localhost:9047, щоб отримати доступ до Dremio. Заповни поля, а потім натисніть Next.

![](https://lh7-us.googleusercontent.com/FthlIDcwImSJElfGu5RPoKOt0SvmGGYa4M2ehjdNiROoz8Sw7YHYlElK0cqcX3l1xr42OLsnm6yeLTdQipQzwnkBMPoCojMN7eVxUo7dnFjOA3CWr8pb56G7Je3zqpD1YJnq4rQt9WYLjRHyKrKDcHg)

- Перейди за адресою http://localhost:9001, щоб увійти в MinIO з ім'ям користувача та паролем які вказані в секретах  ```./secrets/minio_user``` та ```./secrets/minio_password```.  Вам буде запропоновано створити відро.

![](https://lh7-us.googleusercontent.com/FYfQ_4J31qivQHaVcOdxEnBjqkJ5uXVqEEG50-wFnhHQ7buo6CFOKhQHYOljNxFOQVf5CZtkpv7-Gnaj9EPZ9MLQW9doHz4OgWycIW3E7---U0og-1OpVXqPNvL4qOK5qYPZ2ANRpuZEdv3zX_UkQWk)

- Створи відро з назвою ```iceberg-datalake```.
- Потім поверніться до Dremio за адресою http://localhost:9047 та натисніть Add Source та виберіть Nessie.


![](https://lh7-us.googleusercontent.com/anp-2s5Svyc2o32oBHP6iSPFdHmP73meEQdx_siIOyEQUtZe2EVmPiBLZz8csrvrPC8RBa912xy3NM-D-SzG9w5DrGs05xUq5Zz1M5CEl7xCrI7IJQdl92TfmufU_LjrwpBtqPuwVSmCnqVOHjP74gc)

- Встанови ім'я на nessie
- Встанови URL-адресу кінцевої точки на http://nessie:19120/api/v2
- Встанови аутентифікацію на none
![](https://lh7-us.googleusercontent.com/0UozxiXBgJ7I_PDNga1SDlmTwyYUXQTwxWnluvwPw_RmZd7yGqWtVa-Xlp7vrljyulzAPGXdQ1-cppiM3JCh9HPMX83wvpfr_26EZIY3CyUX7C41rUe7WmwZSy8PVK4nDx2TTnoI1GnVf9NWk5YK_5s)


Не натискай Save. Замість цього, у панелі навігації зліва натисніть Storage. MinIO сумісне з S3-API об'єктне сховище та може використовувати ті ж шляхи підключення, що й AWS S3.

- Для вашого ключа доступу встановіть minioadmin
- Для вашого секретного ключа встановіть minioadmin
- Встановіть кореневий шлях на /iceberg-datalake

![](https://lh7-us.googleusercontent.com/yw0q8cmjOnTI0BMV-gqPgFnQpD1B2fAzrmvcQRUCUfgLIARmVRNi8eSOgqu7qzO0Y07_KqWyQtXtM3951_zhp2NZSADBbJA4BGhIkuze76YimL_RvPujd8vmFr5WCtxqu1XvpLekoAMZCfjHxCL4lpI)

- Прокрутіть вниз для наступного набору інструкцій.

Натисніть кнопку Add Property під Connection Properties, щоб створити та налаштувати наступні властивості.
> - fs.s3a.path.style.access встановити true
> - fs.s3a.endpoint встановити minio:9000
> - dremio.s3.compat встановити true
> - Зняти прапорець Encrypt connection

![](https://lh7-us.googleusercontent.com/BrE3VsXd8z8QcS89ejZ8INLPcqgD9axvIRmoRS_5zGzl6bWXK15kau8WT6pIQIFf6yXrBmJRWPXqdwipRUUFPfDQ8oAOpWg8Fv5U7OXMvvwHQ5doW6thfzpzooFs_4odmm7njIIvDnXaVDN7-VMicZE)

- Потім натисни Save. Тепер ви повинні побачити Нессі Каталоги у ваших джерелах даних.

![](https://lh7-us.googleusercontent.com/fMquKEVjPpqP_a6zK0Y79cK0gCTk6XmrSk3AGYeMmW7RGVVys8s0KWUqzTXo4lNleLPIYcHfzk6qRjW16ZWgZPwT72LWm7SWAxXUpY4unahglPCbfEIOEi2K33C5E0aSNy19wUO95-I33QXKxlGW7Yg)

## Створення джерела даних

У Dremio перейдіть до SQL Runner зліва. Переконайтеся, що ```Context``` в верхній правій частині текстового редактора встановлено на наше джерело Nessie. В іншому випадку вам доведеться посилатися на контекст, як ```nessie.SalesData``` замість просто ```SalesData```, щоб запустити цей запит. Скопіюйте та вставте наведений нижче SQL-запит та запустіть його.
```SQL
CREATE TABLE SalesData (
    id INT,
    product_name VARCHAR,
    sales_amount DECIMAL,
    transaction_date DATE
) PARTITION BY (transaction_date);
```
![](https://lh7-us.googleusercontent.com/4nNSaDoq8kI6uZtIgj_6lTV2Lfk2iXwu1hP_nd5kv2Eqmqge9Pl-B00f602kur1kGupxZ7pkdNI5EApomz7r6ZCQgAipx2CgCgKrB1PyTLYjusyBgB7TAX3zblaZVQHb-YRHOXfggmKcLRNrMT-Kq2g)

Виконай запит нижче, щоб вставити дані в таблицю, яку ви щойно створили.

```SQL
INSERT INTO SalesData (id, product_name, sales_amount, transaction_date)
VALUES
    (1, 'ProductA', 1500.00, '2023-10-15'),
    (2, 'ProductB', 2000.00, '2023-10-15'),
    (3, 'ProductA', 1200.00, '2023-10-16'),
    (4, 'ProductC', 1800.00, '2023-10-16'),
    (5, 'ProductB', 2200.00, '2023-10-17');
```
![](https://lh7-us.googleusercontent.com/Inf3tGDm34UTLybX_OCjTisRsbljwNOz5Awbv7HjgNPolH-SxxCP73D--ONL3dLo8YsQRL0yty8SkyBPHJ02PTo_CdRO0FSTPF3t0kqBKUGFNO45G3435KNBhG5uoVNd9Ja55dA6AiTFhNO_7E2LRlc)


Перейдіть до MinIO, щоб переконатися, що ваше озеро даних заповнене таблицями Iceberg.

![](https://lh7-us.googleusercontent.com/mD1lSzuO-GypAeYKShMzSIeHbkdwEFY5lGQXPnARP8tE7l11HBI5XDDaCf7mD-LPS3W5m8HfUJiMQ2Sde0Ind9WkF_SBr1RxFX0l4S5rGJUtqb8GxC_KpuEJ_j7DZMZnew50ep0rPfqCIMSIMWcg6GQ)


## Гілкування та злиття з Нессі
Поверніться до Dremio за адресою http://localhost:9047. Почніть з запиту таблиці на головній гілці за допомогою синтаксису ```AT BRANCH```:

```SQL
SELECT * FROM  nessie.SalesData AT BRANCH main;
```

![](https://lh7-us.googleusercontent.com/1WOJ9N6CyKvabq-YgWVFel55bBRbHaiooXyqlil2EcPXjK2IvFbcwqnLhLq_U3PCYioYjw_zji957zLUnrB-5m9e1x0JvGkMqukVUyIttg17wws9ORaN3GWgpTs90p8hZxU_4U7ZwCy5q9NbMAKmn9M)

Створіть гілку ETL (Extract Transform and Load), щоб мати можливість експериментувати з даними та трансформувати їх без впливу на продакшн.

```SQL
CREATE BRANCH etl_06092023 in nessie
```

У межах гілки ETL вставте нові дані в таблицю:

```SQL
USE BRANCH etl_06092023 in nessie;
INSERT INTO nessie.SalesData (id, product_name, sales_amount, transaction_date) VALUES
(6, 'ProductC', 1400.00, '2023-10-18');
```
Перевірте негайну доступність нових даних у гілці ETL:
```SQL
SELECT * FROM nessie.SalesData AT BRANCH etl_06092023;
```
Зауважте ізольованість змін від користувачів у головній гілці:
```SQL
SELECT * FROM nessie.SalesData AT BRANCH main;
```
Злиття змін з гілки ETL назад у головну гілку:
```SQL
MERGE BRANCH etl_06092023 INTO main in nessie;
```
Знову виберіть головну гілку, щоб переконатися, що зміни дійсно були злиті.
```SQL
SELECT * FROM nessie.SalesData AT BRANCH main
```
Ця стратегія гілкування дозволяє інженерам даних незалежно обробляти численні транзакції по різних таблицях. Коли вони готові, інженери даних можуть об'єднати ці транзакції в одну комплексну багатотабличну транзакцію у головній гілці.

## Висновок
У цьому блозі була розглянута потужність контролю версій, схожого на Git, у інженерії даних, з особливим наголосом на те, як [Nessie](https://www.visitinvernesslochness.com/the-lochness-monster?ref=blog.min.io) безперервно керує версіями даних, гілками та злиттями. Цей посібник крок за кроком демонструє, як Nessie, спільно з Dremio та MinIO як основою для зберігання об'єктів, покращує якість даних та співпрацю в робочих процесах інженерів даних.

## Сервіси

### Nessie
- **Опис**: Сервер Nessie, який використовує MongoDB як сховище версій.
- **Зображення**: `ghcr.io/projectnessie/nessie`
- **Порти**: `${NESSIE_PORT:-19120}:19120`
- **Залежності**: `mongodb`
- **Змінні середовища**:
  - `NESSIE_VERSION_STORE_TYPE=MONGODB`
  - `QUARKUS_MONGODB_CONNECTION_STRING=mongodb://mongodb:${MONGODB_PORT:-27017}/${MONGODB_DB}`
  - `QUARKUS_MONGODB_DATABASE=${MONGODB_DB}`

### MongoDB
- **Опис**: Сервіс MongoDB для зберігання даних використовується в якості backend для Nessie.
- **Зображення**: `mongo:latest`
- **Порти**: `${MONGODB_PORT:-27017}:27017`
- **Томи**:
  - `mongodb_data:/data`
  - `mongodb_logs:/var/log/mongodb`
  - `mongodb_config:/data/configdb`

  ### Minio
  - **Опис**: Сервіс зберігання Minio.
  - **Зображення**: `minio/minio:latest`
  - **Порти**: `${MINIO_CONSOLE_PORT:-9001}:9001`, `${MINIO_PORT:-9000}:9000`
  - **Змінні середовища**:
    - `MINIO_ROOT_USER_FILE=/run/secrets/minio_user`
    - `MINIO_ROOT_PASSWORD_FILE=/run/secrets/minio_password`
    - `MINIO_DOMAIN=storage`
    - `MINIO_REGION_NAME=${MINIO_REGION}`
    - `MINIO_REGION=${MINIO_REGION}`
  - **Томи**:
    - `minio_data:/data`
  - **Секрети**:
    - `minio_user`
    - `minio_password`

  ### Prometheus
  - **Опис**: Сервіс моніторингу Prometheus використовується для збору метрик Minio.
  - **Зображення**: Збирається з Dockerfile.
  - **Порти**: `${PROMETHEUS_PORT:-9090}:9090`
  - **Томи**:
    - `prometheus_data_etc:/etc/prometheus`
    - `prometheus_data:/prometheus`

### Dremio
- **Опис**: Сервіс Dremio.
- **Зображення**: Збирається з Dockerfile.
- **Порти**: `${DREMIO_PORT:-9047}:9047`
- **Томи**:
  - `dremio_data:/opt/dremio/data`




## Додаткові інформація

 - [MINIO Monitoring and Alerting using Prometheus](https://min.io/docs/minio/linux/operations/monitoring/collect-minio-metrics-using-prometheus.html)
 - [Grafana & Prometheus](https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/)
 - [Grafana support for Prometheus](https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/)
 - [Monitoring Dremio](https://docs.dremio.com/current/help-support/lakehouse-arch/operations/monitoring/)
 - [Nessie Server Configurat](https://docs.dremio.com/current/help-support/lakehouse-arch/operations/monitoring/)

