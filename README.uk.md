# Проект Lakehouse з використанням Docker Compose

[![en](https://img.shields.io/badge/lang-en-red.svg)](/README.md)
[![en](https://img.shields.io/badge/lang-uk-green.svg)](/README.uk.md) 

Цей проект демонструє сучасну архітектуру data lakehouse з використанням відкритих сервісів: Nessie (каталог даних з контролем версій), MongoDB (зберігання метаданих) та Dremio (SQL-движок для запитів).

## Початок роботи

- Для запуску проекту потрібно встановити [Docker Compose](https://docs.docker.com/compose/install/)
- Створити `.env` на основі `.env.example`


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


## Налаштування

Зачекай хвилину, а потім перейди за адресою <http://localhost:9047>, щоб отримати доступ до Dremio. Заповни поля, а потім натисни Next.

![Налаштування Dremio](https://lh7-us.googleusercontent.com/FthlIDcwImSJElfGu5RPoKOt0SvmGGYa4M2ehjdNiROoz8Sw7YHYlElK0cqcX3l1xr42OLsnm6yeLTdQipQzwnkBMPoCojMN7eVxUo7dnFjOA3CWr8pb56G7Je3zqpD1YJnq4rQt9WYLjRHyKrKDcHg)

У Dremio натисни Add Source та вибери Nessie.

![Додати джерело Nessie](https://lh7-us.googleusercontent.com/anp-2s5Svyc2o32oBHP6iSPFdHmP73meEQdx_siIOyEQUtZe2EVmPiBLZz8csrvrPC8RBa912xy3NM-D-SzG9w5DrGs05xUq5Zz1M5CEl7xCrI7IJQdl92TfmufU_LjrwpBtqPuwVSmCnqVOHjP74gc)

Встанови ім'я на **nessie**, встанови URL-адресу кінцевої точки на `http://nessie:19120/api/v2`, та встанови аутентифікацію на **none**.

![Конфігурація Nessie](https://lh7-us.googleusercontent.com/0UozxiXBgJ7I_PDNga1SDlmTwyYUXQTwxWnluvwPw_RmZd7yGqWtVa-Xlp7vrljyulzAPGXdQ1-cppiM3JCh9HPMX83wvpfr_26EZIY3CyUX7C41rUe7WmwZSy8PVK4nDx2TTnoI1GnVf9NWk5YK_5s)

**Примітка**: Це налаштування використовує вбудовані можливості зберігання Dremio. Натисни Save для завершення конфігурації.

Тепер ти повинен побачити Nessie Catalogs у своїх джерелах даних.

![Каталоги Nessie](https://lh7-us.googleusercontent.com/fMquKEVjPpqP_a6zK0Y79cK0gCTk6XmrSk3AGYeMmW7RGVVys8s0KWUqzTXo4lNleLPIYcHfzk6qRjW16ZWgZPwT72LWm7SWAxXUpY4unahglPCbfEIOEi2K33C5E0aSNy19wUO95-I33QXKxlGW7Yg)

## Створення джерела даних

У Dremio перейди до SQL Runner зліва. Переконайся, що **Context** в верхній правій частині текстового редактора встановлено на наше джерело Nessie. В іншому випадку тобі доведеться посилатися на контекст як `nessie.SalesData` замість просто `SalesData`, щоб запустити цей запит. Скопіюй та встав наведений нижче SQL-запит та запусти його.

```SQL
CREATE TABLE SalesData (
    id INT,
    product_name VARCHAR,
    sales_amount DECIMAL,
    transaction_date DATE
) PARTITION BY (transaction_date);
```

![Створення таблиці](https://lh7-us.googleusercontent.com/4nNSaDoq8kI6uZtIgj_6lTV2Lfk2iXwu1hP_nd5kv2Eqmqge9Pl-B00f602kur1kGupxZ7pkdNI5EApomz7r6ZCQgAipx2CgCgKrB1PyTLYjusyBgB7TAX3zblaZVQHb-YRHOXfggmKcLRNrMT-Kq2g)

Виконай запит нижче, щоб вставити дані в таблицю, яку ти щойно створив.

```SQL
INSERT INTO SalesData (id, product_name, sales_amount, transaction_date)
VALUES
    (1, 'ProductA', 1500.00, '2023-10-15'),
    (2, 'ProductB', 2000.00, '2023-10-15'),
    (3, 'ProductA', 1200.00, '2023-10-16'),
    (4, 'ProductC', 1800.00, '2023-10-16'),
    (5, 'ProductB', 2200.00, '2023-10-17');
```

![Вставка даних](https://lh7-us.googleusercontent.com/Inf3tGDm34UTLybX_OCjTisRsbljwNOz5Awbv7HjgNPolH-SxxCP73D--ONL3dLo8YsQRL0yty8SkyBPHJ02PTo_CdRO0FSTPF3t0kqBKUGFNO45G3435KNBhG5uoVNd9Ja55dA6AiTFhNO_7E2LRlc)

Дані тепер зберігаються у внутрішньому сховищі Dremio та керуються Nessie для контролю версій.

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

Цей проект демонструє потужність контролю версій у інженерії даних, схожого на Git, з особливим акцентом на те, як Nessie керує версіями даних, гілками та злиттями. Цей покроковий посібник показує, як Nessie разом з Dremio як SQL-движком для запитів і MongoDB для зберігання метаданих покращує якість даних та співпрацю в процесах інженерії даних, використовуючи вбудовані можливості зберігання Dremio.

## Сервіси

### Nessie

- **Опис**: Сервер Nessie, який використовує MongoDB як сховище версій для каталогу даних та контролю версій.
- **Зображення**: `ghcr.io/projectnessie/nessie`
- **Порти**: `${NESSIE_PORT:-19120}:19120`
- **Залежності**: `mongodb`
- **Змінні середовища**:
  - `NESSIE_VERSION_STORE_TYPE=MONGODB`
  - `QUARKUS_MONGODB_CONNECTION_STRING=mongodb://mongodb:${MONGODB_PORT:-27017}/${MONGODB_DB}`
  - `QUARKUS_MONGODB_DATABASE=${MONGODB_DB}`

### MongoDB

- **Опис**: Сервіс MongoDB використовується як backend для Nessie для зберігання метаданих.
- **Зображення**: `mongo:latest`
- **Порти**: `${MONGODB_PORT:-27017}:27017`
- **Томи**:
  - `mongodb_data:/data`
  - `mongodb_logs:/var/log/mongodb`
  - `mongodb_config:/data/configdb`
  - `mongodb_db:/data/db`

### Dremio

- **Опис**: Сервіс Dremio SQL Engine з вбудованими можливостями зберігання.
- **Зображення**: `dremio/dremio-oss:latest`
- **Порти**: `${DREMIO_PORT:-9047}:9047`
- **Томи**:
  - `dremio_data:/opt/dremio/data`




## Додаткова інформація

- [Документація Nessie](https://projectnessie.org/docs/)
- [Документація Dremio](https://docs.dremio.com/)
- [Документація MongoDB](https://docs.mongodb.com/)
- [Документація Apache Iceberg](https://iceberg.apache.org/docs/latest/)
- [Моніторинг Dremio](https://docs.dremio.com/current/help-support/lakehouse-arch/operations/monitoring/)
- [Конфігурація сервера Nessie](https://projectnessie.org/docs/next/nessie-latest/configuration/)

