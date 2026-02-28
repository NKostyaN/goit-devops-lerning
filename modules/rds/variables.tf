variable "name" {
  description = "Назва інстансу або кластера"
  type        = string
}

variable "engine" {
  description = "Тип рушія бази даних для звичайного RDS (наприклад, postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_cluster" {
  description = "Тип рушія бази даних для кластера Aurora (наприклад, aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "aurora_replica_count" {
  description = "Кількість Read Replica інстансів для кластера Aurora"
  type        = number
  default     = 1
}

variable "aurora_instance_count" {
  description = "Загальна кількість інстансів у кластері Aurora (1 primary + репліки)"
  type        = number
  default     = 2
}

variable "engine_version" {
  description = "Версія рушія бази даних для звичайного RDS"
  type        = string
  default     = "14.7"
}

variable "instance_class" {
  description = "Тип (клас) EC2-інстансу для бази даних (наприклад, db.t3.micro, db.t3.medium)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Обсяг виділеного дискового простору (у ГБ) для звичайного RDS-інстансу"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Назва початкової бази даних, яка буде створена автоматично"
  type        = string
}

variable "username" {
  description = "Ім'я головного адміністратора (master user) бази даних"
  type        = string
}

variable "password" {
  description = "Пароль головного адміністратора бази даних"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID існуючої VPC, де буде розгорнута база даних"
  type        = string
}

variable "subnet_private_ids" {
  description = "Список ID приватних підмереж"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Список ID публічних підмереж"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Визначає, чи буде база даних мати публічну IP-адресу для доступу з інтернету"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Увімкнення режиму Multi-AZ (кілька зон доступності) для звичайного RDS для відмовостійкості"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Карта кастомних параметрів для конфігурації Parameter Group бази даних"
  type        = map(string)
  default     = {}
}

variable "use_aurora" {
  description = "Перемикач для вибору: true - створювати кластер Aurora, false - звичайний RDS-інстанс"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Кількість днів для зберігання автоматичних резервних копій (від 0 до 35)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Карта тегів, які будуть призначені всім створеним ресурсам"
  type        = map(string)
  default     = {}
}

variable "parameter_group_family_aurora" {
  description = "Сімейство групи параметрів для кластера Aurora (має відповідати версії рушія)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "engine_version_cluster" {
  description = "Версія рушія бази даних для кластера Aurora"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_rds" {
  description = "Сімейство групи параметрів для звичайного RDS-інстансу (має відповідати версії рушія)"
  type        = string
  default     = "postgres15"
}