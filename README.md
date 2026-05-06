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


Estructura del Proyecto
Lab04-IAC/
├── 📂 application/
│   ├── 🌐 frontend/           # Interfaz web (HTML/JS)
│   └── ƛ lambda-functions/    # Código fuente de las funciones
├── 📂 infrastructure/
│   ├── 📦 modules/            # Módulos reutilizables de Terraform
│   └── 🌍 environments/       # Configuraciones por entorno (Dev, QA, Prod)
└── 📂 docs/                   # Documentación y evidencias

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






