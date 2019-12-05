# Developer Initiated Backup

This requires the [cf MySQL plugin](https://github.com/andreasf/cf-mysql-plugin)

```
$ cf mysqldump small-db album > album_2019-12-05.sql
```

The resulting file, `album_2019-12-05.sql`, is a full backup of the `albums` table.

