# Day One: Developer Focus

* Opening, introductions
* Prerequisites
  - [`cf` CLI](https://github.com/cloudfoundry/cli/releases)
  - A MySQL CLI: `brew install mysql` on Mac; [this](https://stackoverflow.com/questions/3246482/mysql-command-line-client-for-windows)
    discusses the process for Windows
  - The [`cf mysql` plugin](https://github.com/andreasf/cf-mysql-plugin): `$ cf install-plugin -r "CF-Community" mysql-plugin`
  - Java JDK
  - Git CLI: [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is a reference on how to do this for various OS's
  - Use Git to clone the [Spring Music GitHub repo](https://github.com/cloudfoundry-samples/spring-music)

* Briefly, what is the Pivotal Platform (aka PAS, PCF)?
* What is the MySQL “tile” for PAS?

* What is a service instance?  Create one:
```
$ cf create-service p.mysql dev-db-03
```
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

* Work through example of data loading, index creation, viewing query plan, compressing a table:
  - Create the tables: use `./osm_tables.sql`, either copy/paste into a `cf mysql` terminal, or `cf mysql dev-db-03 < ./osm_tables.sql`
  - Set your service instance name in the load script, `./load_osm_data_mysql.sh`
  - Run that script to load data into these tables: `$ ./load_osm_data_mysql.sh`
  - Run query:
    ```
    mysql> select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Review query plan (e.g. EXPLAIN):
    ```
    mysql> explain select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Create an index:
    ```
    mysql> CREATE INDEX osm_k_idx ON osm_k_v(k);
    ```
  - See how that index affects the query plan:
    ```
    mysql> explain select v, count(*) from osm_k_v where k = 'amenity' group by 1 order by 2 desc limit 30;
    ```
  - Re-run the query to see how the index affects its run time.
  - Show how to compress the table:
    ```
    mysql> ALTER TABLE osm_k_v COMPRESSION="lz4";
    mysql> OPTIMIZE TABLE osm_k_v;
    ```

* Discuss table partitioning
Show partition pruning in query plan

