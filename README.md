# 📸 Lab04 IaC

##  Tecnologías

- **IaC:** Terraform ~> 5.0 (AWS Provider)
- **Runtime:** Node.js 20.x
- **Procesamiento de imágenes:** Sharp
- **Cloud:** Amazon Web Services (AWS)
- **Región:** us-east-2 (Ohio)

  ### Prerrequisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado con perfil `fbupao`
- [Node.js](https://nodejs.org/) >= 18.x
- Cuenta AWS con permisos suficientes


## 📁 Estructura del Proyecto

```
Lab04-IAC/
├── application/
│   ├── frontend/
│   │   └── index.html              # Interfaz web de carga de imágenes
│   └── lambda-functions/
│       ├── build.ps1                # Script para empaquetar Lambdas
│       ├── upload/
│       │   ├── index.js             # Código de la Lambda de upload
│       │   └── package.json         # Dependencias (busboy, uuid, aws-sdk)
│       └── crop/
│           ├── index.js             # Código de la Lambda de crop
│           └── package.json         # Dependencias (sharp, aws-sdk)
├── infrastructure/
│   ├── modules/
│   │   ├── networking/              # VPC, Subnets, NAT, VPC Endpoints, SGs
│   │   ├── lambda/                  # Funciones Lambda y Event Source Mapping
│   │   ├── s3/                      # Bucket S3 con versionado y lifecycle
│   │   ├── sqs/                     # Cola principal, DLQ, SNS, Alarma
│   │   ├── iam/                     # Roles y políticas IAM
│   │   ├── api_gateway/             # HTTP API v2 con CORS
│   │   └── observability/           # Dashboard CloudWatch
│   ├── environments/
│   │   ├── dev/                     # Entorno de desarrollo
│   │   ├── qa/                      # Entorno de pruebas
│   │   └── prod/                    # Entorno de producción (NAT HA)
│   ├── variables.tf
│   ├── outputs.tf
│   └── versiones.tf
└── docs/
    └── evidencias/                  # Screenshots y evidencias de despliegue
```


##  Despliegue

## Esto se puede hacer para los 3 entornos tanto como dev, prd y qa

### Paso 1: Empaquetar las funciones Lambda

```En la terminal
cd application/lambda-functions
.\build.ps1
```

Esto generará:
- `upload-lambda.zip`
- `crop-lambda.zip`

### Paso 2: Desplegar la infraestructura

```powershell
cd infrastructure/environments/dev
terraform init
terraform plan
terraform apply
```

### Paso 3: Configurar el frontend

1. Abrir `application/frontend/index.html` en un navegador o usando open live server
2. Ingresar el **API Gateway Endpoint** mostrado en los outputs de Terraform
3. Subir una imagen para probar el flujo

## Destruir la infraestructura

```En la terminal
cd infrastructure/environments/dev
terraform destroy
```






