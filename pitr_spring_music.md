# Point in Time Restore of a table in a MySQL SI

## References

* [Tracker story on this](https://www.pivotaltracker.com/story/show/164738137/comments/201381529)
* [MySQL docs](https://dev.mysql.com/doc/refman/5.7/en/point-in-time-recovery.html)
* [_flashback_ option](https://www.percona.com/blog/2018/04/12/point-in-time-recovery-pitr-in-mysql-mariadb-percona-server/)
* [Binlogs explained](https://www.percona.com/blog/2015/01/20/identifying-useful-information-mysql-row-based-binary-logs/)
* [PiTR -- MySQL official](https://dev.mysql.com/doc/refman/5.7/en/point-in-time-recovery-positions.html)
* Per Andrew Garner, MySQL team (Slack)
There shouldn’t be any discernible performance difference between
leader/follower and a single instance.   There’s some minor load when copying
replication events over the network, but that’s mostly sequential i/o (probably
cached).  Most workloads won’t notice a difference.  There is a performance hit
simply by having replication logs (“binary logs”) enabled - but we enable
binary logs on single instances anyway right now.  The impact of binary logs
has been investigated in the past.  Here’s some relevant (if slightly stale)
[Percona blog posts on this topic](https://www.percona.com/blog/2018/05/04/how-binary-logs-and-filesystems-affect-mysql-performance/)

## PROCEDURE

* Get credentials from [Ops Manager](https://opsman.datamelange.com/api/v0/deployed/director/credentials/director_credentials):
(password is redacted)
```
BOSH Director: 10.0.16.5
{"identity":"director","password":"CYsA[...]L_x8Jq"}
```

* Access the Ops Manager VM:
```
$ ssh -i pcf-ec2.pem ubuntu@opsman.datamelange.com
```

* Set up a "BOSH alias" for that IP address:
```
$ bosh alias-env mike -e 10.0.16.5 --ca-cert /var/tempest/workspaces/default/root_ca_certificate
```

* Log in (provide the credentials shown above):
```
$ bosh -e mike log-in
```

* List the BOSH deployments:
```
$ bosh -e mike deployments
```

* Use the GUID for the MySQL service instance you want to restore, and SSH into it (this one has a single VM):
```
$ bosh -e mike ssh -d service-instance_aacc6cf8-7e3b-4915-a7e2-ef9f859c01b3
```

* In a different terminal, connect via a MySQL CLI:
```
$ cf mysql dev-mysql
```

* There, do an UPDATE that we will later "undo":
```
mysql> update album set release_year = 1980;
```

* Back on the MySQL VM (via the `bosh ssh ...`:
```
$ sudo su -
# cat /var/vcap/jobs/mysql/config/mylogin.cnf
# export MYSQL_PWD=<the_password>
# export PATH=/var/vcap/packages/percona-server/bin:$PATH
# find / -name mysql-bin.000002
# BINLOG=/var/vcap/store/mysql/data/mysql-bin.000002
```

* Dump the binlogs:
```
# mysqlbinlog --base64-output=decode-rows -vv $BINLOG > /tmp/rows_dump.sql
```

* Examine `rows_dump.sql` to locate the offsets in the binary log where the first INSERT
was done, and the same for the last INSERT.  Use these offsets in the `mysqlbinlog` command, below.

* Back in that other terminal, truncate that table:
```
mysql> truncate table album;
Query OK, 0 rows affected (0.01 sec)
```

* In the MySQL VM:
```
# mysqlbinlog --skip-gtids --start-position=3960 --stop-position=22520 $BINLOG | mysql -u admin
```

* Back in that other terminal
```
mysql> select * from album order by artist, title;
```

Notice that the original `release_year` values were restored.

