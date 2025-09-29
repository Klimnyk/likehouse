
# Lakehouse Project using Docker Compose

[![en](https://img.shields.io/badge/lang-en-red.svg)](/README.md)
[![en](https://img.shields.io/badge/lang-uk-greeb.svg)](/README.uk.md) 

This project demonstrates a modern data lakehouse architecture using open-source services: Nessie (data catalog with version control), MongoDB (metadata storage), and Dremio (SQL query engine).

## Getting Started: 
- To run the project, you need to install [Docker Compose](https://docs.docker.com/compose/install/)
- Create ```.env``` based on ```.env.example```

## Running the Project

To run the project, execute the following command:

```sh
docker-compose up -d
```

## Stopping the Project
To stop and remove the containers, run:

```sh
docker-compose down
```

## Configuration

Wait for a minute, then go to <http://localhost:9047> to access Dremio. Fill in the fields and click Next.

![Dremio Setup](https://lh7-us.googleusercontent.com/FthlIDcwImSJElfGu5RPoKOt0SvmGGYa4M2ehjdNiROoz8Sw7YHYlElK0cqcX3l1xr42OLsnm6yeLTdQipQzwnkBMPoCojMN7eVxUo7dnFjOA3CWr8pb56G7Je3zqpD1YJnq4rQt9WYLjRHyKrKDcHg)

In Dremio, click Add Source and select Nessie.

![Add Nessie Source](https://lh7-us.googleusercontent.com/anp-2s5Svyc2o32oBHP6iSPFdHmP73meEQdx_siIOyEQUtZe2EVmPiBLZz8csrvrPC8RBa912xy3NM-D-SzG9w5DrGs05xUq5Zz1M5CEl7xCrI7IJQdl92TfmufU_LjrwpBtqPuwVSmCnqVOHjP74gc)

Set the name to **nessie**, set the endpoint URL to `http://nessie:19120/api/v2`, and set the authentication to **none**.

![Nessie Configuration](https://lh7-us.googleusercontent.com/0UozxiXBgJ7I_PDNga1SDlmTwyYUXQTwxWnluvwPw_RmZd7yGqWtVa-Xlp7vrljyulzAPGXdQ1-cppiM3JCh9HPMX83wvpfr_26EZIY3CyUX7C41rUe7WmwZSy8PVK4nDx2TTnoI1GnVf9NWk5YK_5s)

**Note**: This setup uses Dremio's built-in storage capabilities. Click Save to complete the configuration.

You should now see Nessie Catalogs in your data sources.

![Nessie Catalogs](https://lh7-us.googleusercontent.com/fMquKEVjPpqP_a6zK0Y79cK0gCTk6XmrSk3AGYeMmW7RGVVys8s0KWUqzTXo4lNleLPIYcHfzk6qRjW16ZWgZPwT72LWm7SWAxXUpY4unahglPCbfEIOEi2K33C5E0aSNy19wUO95-I33QXKxlGW7Yg)

## Creating a Data Source

In Dremio, go to SQL Runner on the left. Make sure the **Context** in the top right of the text editor is set to our Nessie source. Otherwise, you will have to reference the context as `nessie.SalesData` instead of just `SalesData` to run this query. Copy and paste the SQL query below and run it.

```SQL
CREATE TABLE SalesData (
        id INT,
        product_name VARCHAR,
        sales_amount DECIMAL,
        transaction_date DATE
) PARTITION BY (transaction_date);
```

![Create Table](https://lh7-us.googleusercontent.com/4nNSaDoq8kI6uZtIgj_6lTV2Lfk2iXwu1hP_nd5kv2Eqmqge9Pl-B00f602kur1kGupxZ7pkdNI5EApomz7r6ZCQgAipx2CgCgKrB1PyTLYjusyBgB7TAX3zblaZVQHb-YRHOXfggmKcLRNrMT-Kq2g)

Run the query below to insert data into the table you just created.

```SQL
INSERT INTO SalesData (id, product_name, sales_amount, transaction_date)
VALUES
        (1, 'ProductA', 1500.00, '2023-10-15'),
        (2, 'ProductB', 2000.00, '2023-10-15'),
        (3, 'ProductA', 1200.00, '2023-10-16'),
        (4, 'ProductC', 1800.00, '2023-10-16'),
        (5, 'ProductB', 2200.00, '2023-10-17');
```

![Insert Data](https://lh7-us.googleusercontent.com/Inf3tGDm34UTLybX_OCjTisRsbljwNOz5Awbv7HjgNPolH-SxxCP73D--ONL3dLo8YsQRL0yty8SkyBPHJ02PTo_CdRO0FSTPF3t0kqBKUGFNO45G3435KNBhG5uoVNd9Ja55dA6AiTFhNO_7E2LRlc)

The data is now stored in Dremio's internal storage and managed by Nessie for version control.

## Branching and Merging with Nessie

Go back to Dremio at <http://localhost:9047>. Start by querying the table on the main branch using the syntax `AT BRANCH`:

```SQL
SELECT * FROM  nessie.SalesData AT BRANCH main;
```

![Query Main Branch](https://lh7-us.googleusercontent.com/1WOJ9N6CyKvabq-YgWVFel55bBRbHaiooXyqlil2EcPXjK2IvFbcwqnLhLq_U3PCYioYjw_zji957zLUnrB-5m9e1x0JvGkMqukVUyIttg17wws9ORaN3GWgpTs90p8hZxU_4U7ZwCy5q9NbMAKmn9M)

Create a branch called ETL (Extract Transform and Load) to be able to experiment with and transform the data without impacting production.

```SQL
CREATE BRANCH etl_06092023 in nessie
```

Within the ETL branch, insert new data into the table:

```SQL
USE BRANCH etl_06092023 in nessie;
INSERT INTO nessie.SalesData (id, product_name, sales_amount, transaction_date) VALUES
(6, 'ProductC', 1400.00, '2023-10-18');
```

Check the immediate availability of the new data in the ETL branch:

```SQL
SELECT * FROM nessie.SalesData AT BRANCH etl_06092023;
```

Note the isolation of changes from users on the main branch:

```SQL
SELECT * FROM nessie.SalesData AT BRANCH main;
```

Merge the changes from the ETL branch back into the main branch:

```SQL
MERGE BRANCH etl_06092023 INTO main in nessie;
```

Select the main branch again to verify that the changes have indeed been merged.

```SQL
SELECT * FROM nessie.SalesData AT BRANCH main
```

This branching strategy allows data engineers to independently process multiple transactions on different tables. When they are ready, data engineers can merge these transactions into one comprehensive multi-table transaction on the main branch.

## Conclusion

This project demonstrates the power of version control in data engineering, similar to Git, with a focus on how Nessie manages data versions, branches, and merges. This step-by-step guide shows how Nessie, along with Dremio as the SQL query engine and MongoDB for metadata storage, improves data quality and collaboration in data engineering workflows using Dremio's built-in storage capabilities.


## Services

### Nessie

- **Description**: Nessie server that uses MongoDB as a version store for data catalog and version control.
- **Image**: `ghcr.io/projectnessie/nessie`
- **Ports**: `${NESSIE_PORT:-19120}:19120`
- **Dependencies**: `mongodb`
- **Environment Variables**:
  - `NESSIE_VERSION_STORE_TYPE=MONGODB`
  - `QUARKUS_MONGODB_CONNECTION_STRING=mongodb://mongodb:${MONGODB_PORT:-27017}/${MONGODB_DB}`
  - `QUARKUS_MONGODB_DATABASE=${MONGODB_DB}`

### MongoDB

- **Description**: MongoDB service is used as a backend for Nessie to store metadata.
- **Image**: `mongo:latest`
- **Ports**: `${MONGODB_PORT:-27017}:27017`
- **Volumes**:
  - `mongodb_data:/data`
  - `mongodb_logs:/var/log/mongodb`
  - `mongodb_config:/data/configdb`
  - `mongodb_db:/data/db`

### Dremio

- **Description**: Dremio SQL Engine service with built-in storage capabilities.
- **Image**: `dremio/dremio-oss:latest`
- **Ports**: `${DREMIO_PORT:-9047}:9047`
- **Volumes**:
  - `dremio_data:/opt/dremio/data`

## Additional Information

- [Nessie Documentation](https://projectnessie.org/docs/)
- [Dremio Documentation](https://docs.dremio.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Apache Iceberg Documentation](https://iceberg.apache.org/docs/latest/)
- [Monitoring Dremio](https://docs.dremio.com/current/help-support/lakehouse-arch/operations/monitoring/)
- [Nessie Server Configuration](https://projectnessie.org/docs/next/nessie-latest/configuration/)
