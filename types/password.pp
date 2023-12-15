# Allowed values for secrets
type Barman::Password = Optional[
  Variant[
    String,
    Sensitive[String],
    Integer
  ]
]
