# Allowed backup age
type Barman::BackupAge = Optional[Pattern[/^[1-9][0-9]* (HOUR|DAY|WEEK|MONTH)S?$/]]
