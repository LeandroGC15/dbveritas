# Veritas - Despliegue con Docker Compose

Este directorio contiene la configuración de despliegue unificada para el backend y la base de datos de Veritas.

## 📋 Requisitos Previos

- Docker y Docker Compose instalados
- Git (para clonar los repositorios)

## 🚀 Despliegue Rápido

### Opción 1: Repositorios Separados (Recomendado)

Si tienes los repositorios en carpetas separadas:

```bash
# Estructura esperada:
# proyecto/
# ├── Veritasbackend/    (repo del backend)
# └── dbveritas/         (este repo)

# 1. Clonar ambos repositorios
git clone <url-backend> Veritasbackend
git clone <url-dbveritas> dbveritas

# 2. Configurar variables de entorno
cd dbveritas
cp .env.example .env
# Editar .env con tus valores de producción

# 3. Levantar servicios
docker compose up -d --build
```

### Opción 2: Monorepo

Si todo está en un solo repositorio:

```bash
# 1. Clonar el repositorio
git clone <url-repo> veritas
cd veritas/dbveritas

# 2. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus valores

# 3. Levantar servicios
docker compose up -d --build
```

## 🔧 Configuración

### Variables de Entorno

Copia `.env.example` a `.env` y configura:

```env
# Database
DB_USER=postgres
DB_PASSWORD=tu-password-seguro
DB_NAME=veritas_db
DB_EXTERNAL_PORT=5434  # Puerto externo (opcional, solo si necesitas acceso desde fuera)

# Backend
PORT=8080
GIN_MODE=release

# JWT (¡IMPORTANTE! Cambiar en producción)
JWT_SECRET=tu-jwt-secret-super-seguro
JWT_EXPIRATION=24h

# CORS (configurar con tu dominio)
CORS_ALLOWED_ORIGINS=https://tu-dominio.com
```

### Estructura de Directorios

El `docker-compose.yml` espera esta estructura:

```
proyecto/
├── Veritasbackend/          # Repositorio del backend
│   ├── Dockerfile
│   ├── cmd/
│   └── ...
└── dbveritas/               # Este directorio
    ├── docker-compose.yml
    └── .env
```

## 📦 Comandos Útiles

```bash
# Levantar servicios
docker compose up -d --build

# Ver logs
docker compose logs -f

# Ver logs solo del backend
docker compose logs -f backend

# Ver logs solo de postgres
docker compose logs -f postgres

# Ver estado de contenedores
docker compose ps

# Detener servicios
docker compose down

# Detener y eliminar volúmenes (¡CUIDADO! Borra datos)
docker compose down -v

# Reiniciar solo el backend
docker compose restart backend

# Reconstruir solo el backend
docker compose up -d --build backend

# Ejecutar seed (poblar base de datos)
docker compose exec backend go run cmd/seed/main.go
```

## 🌐 Despliegue en Servidor

### 1. Preparar el Servidor

```bash
# Instalar Docker y Docker Compose
sudo apt update
sudo apt install docker.io docker-compose-plugin

# Agregar usuario al grupo docker (opcional)
sudo usermod -aG docker $USER
```

### 2. Clonar y Configurar

```bash
# Clonar repositorios
git clone <url-backend> Veritasbackend
git clone <url-dbveritas> dbveritas

# O si es monorepo
git clone <url-repo> veritas
cd veritas/dbveritas

# Configurar variables de entorno
cp .env.example .env
nano .env  # Editar con valores de producción
```

### 3. Desplegar

```bash
# Levantar servicios
docker compose up -d --build

# Verificar que todo está corriendo
docker compose ps
docker compose logs -f
```

### 4. Configurar Firewall (si es necesario)

```bash
# Permitir puerto del backend
sudo ufw allow 8080/tcp

# Si necesitas acceso externo a PostgreSQL (no recomendado)
sudo ufw allow 5434/tcp
```

## 🔒 Seguridad para Producción

1. **Cambiar todas las contraseñas por defecto**
2. **Usar un JWT_SECRET fuerte y único**
3. **Configurar CORS con tu dominio específico**
4. **No exponer el puerto de PostgreSQL** (eliminar la línea `ports` del servicio postgres)
5. **Usar HTTPS** con un reverse proxy (nginx/traefik)
6. **Configurar backups** de la base de datos

## 🐛 Troubleshooting

### Puerto 5432 ya en uso

Si el puerto 5432 está ocupado, cambia `DB_EXTERNAL_PORT` en el `.env`:

```env
DB_EXTERNAL_PORT=5434
```

### El backend no se conecta a la base de datos

Verifica que:
- Ambos servicios estén en la misma red (`veritas_network`)
- El backend use `DB_HOST=postgres` (nombre del servicio)
- PostgreSQL esté saludable: `docker compose ps`

### Error al construir el backend

Asegúrate de que:
- El directorio `Veritasbackend` existe y está al mismo nivel que `dbveritas`
- El `Dockerfile` existe en `Veritasbackend/`
- Tienes permisos de lectura en ambos directorios

## 📝 Notas

- Los datos de PostgreSQL se persisten en el volumen `postgres_data`
- El backend se reconstruye automáticamente al hacer `docker compose up --build`
- Las migraciones se ejecutan automáticamente al iniciar el backend

