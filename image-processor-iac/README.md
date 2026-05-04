Image Processor  LABORATORIO SEMANA 04
Implementación completa en Terraform de una arquitectura en AWS basada en el diagrama Mermaid proporcionado.
Requisitos

Terraform >= 1.0
AWS CLI v2 configurado con SSO
Cuenta AWS con permisos suficientes
Acceso a la región us-east-2


Estructura del Proyecto

image-processor-iac/
├── modules/
│   ├── networking/      # VPC, subnets, NATs, VPC endpoints
│   ├── iam/             # Roles y policies
│   ├── s3/              # Bucket S3
│   ├── sqs/             # Queues y alarmas
│   ├── lambda/          # Lambda functions
│   ├── api_gateway/     # HTTP API v2
│   └── observability/   # CloudWatch dashboards
├── environments/
│   ├── dev/             # Entorno DEV (1 NAT, low cost)
│   ├── qa/              # Entorno QA (1 NAT, low cost)
│   └── prod/            # Entorno PROD (2 NATs, HA)
├── versions.tf          # Providers y versiones
├── variables.tf         # Variables globales
├── outputs.tf           # Outputs globales
└── README.md            # Este archivo

Despliegue
1. Dev Environment

cd environments/dev

# Inicializar Terraform
terraform init

# Ver el plan de despliegue
terraform plan

# Aplicar los cambios
terraform apply


2. QA Environment

cd environments/qa

terraform init
terraform plan
terraform apply
terraform output

3. Prod Environment

cd environments/prod

terraform init
terraform plan
terraform apply
terraform output

Destrucción de Recursos
Para eliminar todos los recursos y evitar costos:
Dev

cd environments/dev
terraform destroy

QA

cd environments/qa
terraform destroy

Prod

cd environments/prod
terraform destroy


