# Day One: Developer Focus

* Opening, introductions
* Prerequisites
  - `cf` CLI
  - A MySQL CLI (e.g. `mysql`)
  - The `cf mysql` plugin
  - Java JDK
  - Git CLI (e.g. `git`)
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

* Work through example:
(Refer to `workshop_02.md` from Singapore sessions)
Load 1M rows (see `mysql-shell_bulk_load.txt` and how to adapt to `cf mysql`)
Run query
Review query plan (e.g. EXPLAIN)
Create an index
Re-run the query
Review query plan now that there is an index
Show how to compress the table

* Discuss table partitioning
Show partition pruning in query plan

