# Повний CI/CD-процес із використанням Jenkins + Helm + Terraform + Argo CD

Цей проєкт автоматично збирає Docker-образ для Django-застосунку, публікує образ в Amazon ECR, оновлює Helm chart у репозиторії з правильним тегом, синхронізує застосунок у кластері через Argo CD, який підхоплює зміни з Git.

## Структура проєкту

```
Lesson-8-9/
│
├── main.tf                # Головний файл для підключення модулів
├── backend.tf             # Налаштування бекенду для стейтів S3 + DynamoDB
├── outputs.tf             # Загальні виводи ресурсів
├── Jenkinsfile            # Конфігурація дженкінса
├── variables.tf           # Змінні для підключення GitHub
├── versions.tf            # Налаштування версій модулів
│
├── modules/               # Каталог з усіма модулями
│   ├── s3-backend/        # Модуль для S3 та DynamoDB
│   ├── vpc/               # Модуль для VPC
│   ├── ecr/               # Модуль для ECR
│   ├── eks/               # Модуль для Kubernetes кластера
│   ├── jenkins/           # Модуль для Helm-установки Jenkins
│   └── argo_cd/           # Модуль для Helm-установки Argo CD
│
├── charts/
│   └── django-app/        # Helm chart для застосунку
│
├── my_django_project/     # Django застосунок + Dockerfile
│
└── README.md              # Документація проєкту (цей файл)
```

## Команди для роботи

Спочатку створіть файл `terraform.tfvars` в корені проекту з логіном та токеном від **GitHub** акаунту:
```bash
github_username = "ваш-логін"
github_token    = "ваш-токен"
```
Створіть інфраструктуру:
```bash
terraform apply
```
Коли інфраструктуру створено, налаштуйте **Kubernetes**:
```bash
aws eks update-kubeconfig --region eu-west-1 --name goit-lern-nkos-cluster
```

## Перевірка роботи Jenkins

Для отримання `<EXTERNAL-IP>` запустити команду:

```bash
kubectl get svc -n jenkins
```

Перейти по `http://<EXTERNAL-IP>` адресі, ввести логін `admin`, пароль `admin123` та запустити білд **goit-django-docker** пайплайну
### ArgoCD
![jenkins](screens/jenkins.png)

## Перевірка роботи Argo CD

Для отримання `<EXTERNAL-IP>` запустити команду:

```bash
kubectl get svc -n argocd
```
Для отримання паролю запустити команду:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```
Перейти по `http://<EXTERNAL-IP>` адресі, ввести логін `admin`, пароль, який отримали вище та перевірити **django-app** статус. Має бути **Synced, Healthy**
### ArgoCD
![argocd](screens/argocd.png)

## Перевірка роботи Django

Для отримання `<EXTERNAL-IP>` запустити команду:
```bash
kubectl get svc -n default django-app-django
```
Перейти по `http://<EXTERNAL-IP>` адресі.

### Django
![django](screens/django.png)
