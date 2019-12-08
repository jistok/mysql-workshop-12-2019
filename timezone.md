# Setting the Time Zone for a Pivotal MySQL Service Instance

* [Nice Stackoverflow post](https://stackoverflow.com/questions/930900/how-do-i-set-the-time-zone-of-mysql)
* [DATETIME vs. TIMESTAMP](https://stackoverflow.com/questions/409286/should-i-use-the-datetime-or-timestamp-data-type-in-mysql)
* [Note on TIMESTAMP storage](https://dev.mysql.com/doc/refman/5.7/en/datetime.html)
> MySQL converts TIMESTAMP values from the current time zone to UTC for storage,
> and back from UTC to the current time zone for retrieval. (This does not occur
> for other types such as DATETIME.)

