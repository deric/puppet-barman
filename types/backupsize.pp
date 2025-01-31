# Allowed backup size
type Barman::BackupSize = Optional[Pattern[/^[1-9][0-9]*( (k|Ki|M|Mi|G|Gi|T|Ti))?$/]]
