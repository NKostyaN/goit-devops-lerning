# Terraform-структура для інфраструктури на AWS

Цей проєкт створює інфраструктуру AWS за допомогою Terraform та налаштовує наступне:

- Синхронізацію стейт-файлів у S3 з використанням DynamoDB для блокування.
- Мережеву інфраструктуру (VPC) з публічними та приватними підмережами та NAT Gateway.
- ECR (Elastic Container Registry) для зберігання Docker-образів.
   
## Структура проєкту

```
lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проєкту (цей файл)
```

## Модулі
Проєкт містить наступні модулі:

### 1. s3-backend
Створює:
- S3 bucket з versioning та encryption
- DynamoDB таблицю для блокування Terraform state

### 2. vpc
Створює:
- VPC (10.0.0.0/16)
- Три public subnets
- Три private subnets
- Internet Gateway
- NAT Gateway
- Route tables та асоціації

### 3. ecr
Створює:
- ECR репозиторій
- Увімкнене сканування образів
- Політику доступу для акаунта

## Команди для роботи

### Ініціалізація
```bash
terraform init
```

### Перегляд плану
```bash
terraform plan
```

### Створення інфраструктури
```bash
terraform apply
```

### Видалення інфраструктури
```bash
terraform destroy
```

## Налаштування backend

> [!Important]
> Для того, щоб Terraform зберігав свій стан у S3 bucket, треба спочатку його створити, а вже потім активувати Backend, для цього послідовність дій має бути наступна:

1. Тимчасово закоментувати блок backend у `backend.tf`
2. Запустити:
   ```bash
   terraform init
   terraform apply
   ```
3. Розкоментувати блок backend у `backend.tf`
4. Повторно виконати:
   ```bash
   terraform init
   ```
5. Підтвердити перенесення state у S3

## Outputs

Після `terraform apply` ви отримаєте:

- ID створеної VPC
- Списки public/private subnet IDs
- URL ECR репозиторію
- Назву S3 bucket
- Назву DynamoDB таблиці
