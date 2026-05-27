# Cliente Service - Prueba Técnica Audifarma

Autor: Oscar Julian Gonzalez Sanchez
Preparado para: Audifarma
Fecha: 27 de Mayo 2026
Descripción: Microservicio desarrollado como prueba técnica para la vacante de Desarrollador Microservicios.

## 📄 Descripción General
Microservicio RESTful para la gestión de clientes y sus direcciones. Construido con Spring Boot 3.5.14 y Java 21, aplicando estrictamente los principios de la **Arquitectura Hexagonal (Puertos y Adaptadores)**, buenas prácticas de Clean Code y principios SOLID. 

El proyecto utiliza una base de datos H2 en memoria para facilitar las pruebas locales y expone métricas de salud y estado mediante Spring Boot Actuator.

## 🏗️ Estructura de Paquetes (Arquitectura Hexagonal)
El proyecto divide sus responsabilidades en tres capas principales, garantizando un bajo acoplamiento:

```text
com.audifarma.clienteservice
 ├── domain/           # Lógica de negocio pura (Entidades) y puertos. Cero dependencias externas.
 ├── application/      # Casos de uso, orquestación (Servicios) y DTOs (Records inmutables).
 └── infrastructure/   # Adaptadores de entrada (REST Controllers) y salida (JPA, H2).
```

## ⚙️ Requisitos Previos
Para interactuar con el proyecto en los diferentes entornos, necesitas tener instalado:
* **Java JDK 21**
* **Maven** (El proyecto incluye el wrapper `mvnw`)
* **Docker** y **Docker Compose**
* **kubectl** y un clúster local (ej. Minikube, kind o Docker Desktop) para el despliegue en Kubernetes.

---

## 🚀 Instrucciones de Ejecución

### 1. Ejecutar localmente con Maven
Abre una terminal en la raíz del proyecto y ejecuta el siguiente comando:
```bash
./mvnw spring-boot:run 
```
*(En Windows usa `.\mvnw.cmd spring-boot:run`)*
La aplicación iniciará en el puerto 8080 y la base de datos H2 se configurará y poblará automáticamente.

### 2. Construir y ejecutar con Docker
Gracias al archivo `docker-compose.yml`, puedes levantar la imagen y el contenedor con un solo comando desde la raíz del proyecto:
```bash
docker-compose up -d --build
```
*Para detener y eliminar el contenedor, utiliza el comando `docker-compose down`.*

### 3. Desplegar en Kubernetes
Asegúrate de que tu clúster local de Kubernetes esté corriendo. Luego, aplica los manifiestos ubicados en la carpeta `k8s/`:
```bash
kubectl apply -f k8s/
```
Esto desplegará:
* Un **Deployment** con Liveness y Readiness probes configurados.
* Un **Service** de tipo NodePort para exponer la aplicación.

Para interactuar con la API desde fuera del clúster (entorno local), utilizar el siguiente comando:
```bash
kubectl port-forward svc/cliente-service 8080:8080
```
---

## 🧪 Ejemplos para consumir la API (cURL)

Una vez que la aplicación esté corriendo, puedes usar **Swagger UI** en `http://localhost:8080/swagger-ui/index.html` o usar estos comandos en tu terminal:

### 1. Crear un nuevo cliente
```bash
curl -X POST http://localhost:8080/api/clientes \
-H "Content-Type: application/json" \
-d '{
  "nombre": "Carlos",
  "apellido": "Pérez",
  "numeroDocumento": "10203040",
  "tipoDocumento": "CC",
  "edad": 28,
  "activo": true,
  "direcciones": []
}'
```

### 2. Consultar un cliente por documento
```bash
curl -X GET http://localhost:8080/api/clientes/10203040
```

### 3. Agregar una dirección a un cliente existente
```bash
curl -X POST http://localhost:8080/api/clientes/10203040/direcciones \
-H "Content-Type: application/json" \
-d '{
  "departamento": "Risaralda",
  "ciudad": "Pereira",
  "direccion": "Carrera 10 # 5-20"
}'
```
