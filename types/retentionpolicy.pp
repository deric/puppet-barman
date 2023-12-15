# Backup's retention policy
type Barman::RetentionPolicy = Optional[Pattern[/^(^$|REDUNDANCY [1-9][0-9]*|RECOVERY WINDOW OF [1-9][0-9]* (DAY|WEEK|MONTH)S?)$/]]
