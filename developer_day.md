# Day One: Developer Focus

* Opening, introductions
* Prerequisites
  - [`cf` CLI](https://github.com/cloudfoundry/cli/releases)
  - A MySQL CLI: `brew install mysql` on Mac; [this](https://stackoverflow.com/questions/3246482/mysql-command-line-client-for-windows)
    discusses the process for Windows
  - The [`cf mysql` plugin](https://github.com/andreasf/cf-mysql-plugin): `cf install-plugin -r "CF-Community" mysql-plugin`
  - Java JDK

* Briefly, what is the Pivotal Platform (aka PAS, PCF)?
* What is the MySQL “tile” for PAS?

* What is a service instance?  Create one:

**In these steps, the `-03` is present to differentiate one student from another; use your assigned ID here in place of the `03`**

```
cf create-service p.mysql dev-db-03
```

* Download the [Zip file](https://github.com/cloudfoundry-samples/spring-music/archive/master.zip) containing the _Spring Music_ app,
then unzip the downloaded file.
  - Change into the resulting directory
  - Edit the `./manifest.yml` file, appending your team ID to the `name` value; e.g. `name: spring-music-03`
  - Build the Spring Boot app: `./gradlew clean build`

* How do you deploy an app to PAS?
```
cf push --no-start
```
* How do apps access services?
```
cf bind-service spring-music-03 dev-db-03
cf start spring-music-03
```
* Access the credentials for the bound service instance:
```
cf env spring-music-03
```
* The _better_ way to fetch credentials for CLI login to service instances:
```
cf create-service-key dev-db-03 sk-03-01
```
* A cf CLI plugin provides access to service instances using an SSH tunnel:
```
cf mysql dev-db-03
```
* Using a similar approach, a developer is able to make a backup:
```
cf mysqldump dev-db-03 album > my-db-dump-$( date +%s ).sql
```

* Work through example of data loading, index creation, viewing query plan, compressing a table.
  - Create the tables: use `./osm_tables.sql`, either copy/paste into a `cf mysql` terminal, or `cf mysql dev-db-03 < ./osm_tables.sql`
  - Set your service instance name in the load script, `./load_osm_data_mysql.sh`
  - Run that script to load data into these tables: `./load_osm_data_mysql.sh`
    **Caveat**: if you need to load large data sets, it's better to do that in smaller chunks, as discussed
    [here](./mysql-shell_bulk_load.md).
  - Run query:
    ```
    select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Review query plan (e.g. EXPLAIN):
    ```
    explain select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Create an index:
    ```
    CREATE INDEX osm_k_idx ON osm_k_v(k);
    ```
  - See how that index affects the query plan:
    ```
    explain select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Re-run the query to see how the index affects its run time.
  - Show how to compress the table:
    ```
    ALTER TABLE osm_k_v COMPRESSION="lz4";
    OPTIMIZE TABLE osm_k_v;
    ```

* Discuss table partitioning and show partition pruning.
  - Create a very simple, partitioned, table:
    ```
    DROP TABLE IF EXISTS members;
    CREATE TABLE members
    (
      id INT NOT NULL,
      firstname VARCHAR(25) NOT NULL,
      lastname VARCHAR(25) NOT NULL,
      username VARCHAR(16) NOT NULL,
      email VARCHAR(35),
      joined DATE NOT NULL,
      -- PRIMARY KEY (id) /* This won't work. */
      PRIMARY KEY (id, joined) /* The partition columns are required in the PK. */
    )
    PARTITION BY RANGE COLUMNS (joined)
    (
        PARTITION p0 VALUES LESS THAN ('1960-01-01'),
        PARTITION p1 VALUES LESS THAN ('1970-01-01'),
        PARTITION p2 VALUES LESS THAN ('1980-01-01'),
        PARTITION p3 VALUES LESS THAN ('1990-01-01'),
        PARTITION p4 VALUES LESS THAN MAXVALUE
    );
    ```
  - Insert a row:
    ```
    INSERT INTO members VALUES (1, 'Joe', 'Jones', 'jjones', 'jj@acme.com', '1986-07-19');
    ```
  - Get the query plan for this query:
    ```
    EXPLAIN SELECT * FROM members WHERE joined < '1989-01-01';
    ```
  - Alter the predicate and see how the explain plan changes:
    ```
    EXPLAIN SELECT * FROM members WHERE joined < '1989-01-01' AND joined > '1980-01-01';
    ```

