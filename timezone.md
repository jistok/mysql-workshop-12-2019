# Setting the Time Zone for a Pivotal MySQL Service Instance

## Rationale behind using UTC
As organizations are increasingly operating globally, it is not possible to know where those users may be located,
or in which time zone they are.  We know, if we have a data center, where it is located, but we may have the data
replicated in multiple locations, each operating on its own time zone.  Given this, we believe it is simplest to
adopt the convention that all data is stored in UTC, and we know this to be true for all our database systems.  When
a user access the application, we can determine the user's location and therefore their expected time zone, and apply
that to their view of the data, for their session.

## References
* [Stackoverflow on setting time zone](https://stackoverflow.com/questions/930900/how-do-i-set-the-time-zone-of-mysql)
* [Discussion: DATETIME vs. TIMESTAMP](https://stackoverflow.com/questions/409286/should-i-use-the-datetime-or-timestamp-data-type-in-mysql)

* [A note on storage of TIMESTAMP values](https://dev.mysql.com/doc/refman/5.7/en/datetime.html)
> MySQL converts TIMESTAMP values from the current time zone to UTC for storage,
> and back from UTC to the current time zone for retrieval. (This does not occur
> for other types such as DATETIME.)


