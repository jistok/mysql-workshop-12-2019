# Bulk loading data using MySQL-Shell

I would strongly recommend chunking the import into smaller, more manageable
transaction sizes.   Probably the easiest way to do this is to use the
[mysql-shell utility](https://dev.mysql.com/doc/mysql-shell/8.0/en/). In
particular, it has built-in functionality to import files in small chunks in
parallel across multiple threads
[here](https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities-parallel-table.html)
is a referene.

* You can do something like this:
```
# mysqlsh 
> \connect mysql://user:password@host:port
> util.importTable("foo.csv", {schema: "service_instance_db", table: "foo" })
```
By default, that chunks the data into transactions of about 20 MB each, loading
in parallel across about 8 threads; these values can be adjusted through options as
documented in the above link.

