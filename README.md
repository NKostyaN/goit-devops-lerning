# Django-застосунок у Kubernetes-кластері на AWS

Цей проєкт розгортає Django-застосунок у Kubernetes-кластері, використовуючи Terraform для інфраструктури, ECR для зберігання Docker-образу та Helm для деплою.

## Структура проєкту

```
lesson-7/
│
├── main.tf                   # Головний файл для підключення модулів
├── backend.tf                # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf                # Загальні виводи ресурсів
├── versions.tf               # Файл для фіксації версій провайдерів
│
├── modules/                  # Каталог з усіма модулями
│   ├── s3-backend/           # Модуль для S3 та DynamoDB
│   │
│   ├── vpc/                  # Модуль для VPC
│   │
│   ├── ecr/                  # Модуль для ECR
│   │
│   └── eks/                  # Модуль для Kubernetes кластера
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── hpa.yaml
│       │   ├── configmap.yaml
│       │   └── secret.yaml
│       ├── Chart.yaml
│       └── values.yaml       # ConfigMap зі змінними середовища
└── README.md                 # Документація проєкту (цей файл)
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
- Політики доступу для акаунта

### 4. eks
Створює:
- Kubernetes кластер
- Node Group для EKS
- Політики доступу для акаунта


### 5. Helm-чарт для розгортання Django-застосунку в Kubernetes.
- **Deployment** — розгортання Django з образом з ECR
- **Service** — LoadBalancer для зовнішнього доступу
- **ConfigMap** — змінні середовища для застосунку
- **HPA** — автомасштабування (2-6 подів коли CPU > 70%)


## Безпека
- **Kubernetes Secrets**: Усі конфіденційні дані (паролі БД) винесені з `values.yaml` у секрети.
- **ALLOWED_HOSTS**: У `settings.py` необхідно додати адресу `EXTERNAL-IP` вашого LoadBalancer.
- **IAM Roles**: Доступ до ECR та EKS обмежений специфічними IAM політиками.

## Команди для роботи

### Terraform
```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

### Налаштування Kubernetes
```bash
aws eks update-kubeconfig --region eu-west-1 --name goit-lern-nkos-cluster
```

### Завантаження Docker-образу до ECR
```bash
# Логін до AWS
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 849990178824.dkr.ecr.eu-west-1.amazonaws.com
# Тег
docker tag <your-image>:latest 849990178824.dkr.ecr.eu-west-1.amazonaws.com/goit-lern-nkos-lesson-5-ecr:latest
# Пуш
docker push 849990178824.dkr.ecr.eu-west-1.amazonaws.com/goit-lern-nkos-lesson-5-ecr:latest
```

### Розгортання Helm-чарту
```bash
helm install <your-app-name> charts/django-app --namespace prod
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

- Створений EKS-кластер  
- Налаштований ECR  
- Django-додаток запушений у Docker-образі
- Деплой у Kubernetes через Helm
- Service типу LoadBalancer працює
- HPA масштабує поди
- ConfigMap використовується застосунком
