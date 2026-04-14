# Windows-Compatible Docker Compose + Registry Makefile

A production-ready Makefile for Windows that simplifies Docker Compose workflows with registry integration. Perfect for Windows developers who want to automate container builds, deployments, and registry operations.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Commands Reference](#commands-reference)
- [Usage Examples](#usage-examples)
- [Workflows](#workflows)
- [Registry Setup](#registry-setup)
- [Docker Compose Examples](#docker-compose-examples)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [Migrating from Linux/Mac](#migrating-from-linuxmac)
- [FAQ](#faq)

## 🎯 Overview

This Makefile is specifically designed for **Windows environments** using CMD as the shell. It provides a consistent, automated workflow for Docker Compose operations without requiring WSL, PowerShell, or Unix-like tools.

### Why Windows-Specific?

| Feature | This Makefile | Linux/Mac Makefiles |
|---------|---------------|---------------------|
| **Shell** | CMD (native) | Bash |
| **Path separators** | `\` (auto-handled) | `/` |
| **Environment vars** | `%VAR%` syntax | `$VAR` syntax |
| **Conditionals** | CMD `if` statements | Bash `if` statements |
| **Colors** | Disabled (CMD compatible) | ANSI colors |
| **Works on** | Windows 10/11 | Linux/macOS/WSL |

## ✨ Features

- ✅ **Native Windows Support** - Works in regular CMD, no WSL required
- ✅ **Docker Compose Integration** - Full compose workflow automation
- ✅ **Registry Support** - Push/pull to Docker Hub, GHCR, private registries
- ✅ **Multi-Service Building** - Build specific services or all at once
- ✅ **Production Ready** - Separate dev/prod compose files
- ✅ **Error Handling** - Proper error checking for Windows environment
- ✅ **Zero Dependencies** - Only requires Docker and Make for Windows
- ✅ **CI/CD Friendly** - Works in Windows-based CI runners

## 🔧 Prerequisites

### Required Software

| Software | Version | Installation |
|----------|---------|--------------|
| **Docker Desktop for Windows** | 4.20+ | [Download](https://docs.docker.com/desktop/install/windows-install/) |
| **GNU Make for Windows** | 4.0+ | See installation below |
| **Git (optional)** | Any | [Download](https://git-scm.com/download/win) |

### Verify Installation

Open **Command Prompt (CMD)** as Administrator:

```cmd
docker --version
docker compose version
make --version
```

Expected output:
```
Docker version 24.0.0
Docker Compose version v2.20.0
GNU Make 4.3
```

## 🚀 Quick Start

```cmd
# 1. Download the Makefile
curl -O https://raw.githubusercontent.com/majiicmajic/Majic-Docker-Windows-Makefile

# 2. Create example docker-compose.yml
notepad docker-compose.yml
# (Copy example from below)

# 3. Setup environment
make setup-env

# 4. Build and run
make build
make up

# 5. Check status
make ps
make logs

# 6. Stop
make down
```

## 📦 Installation

### Option 1: Chocolatey (Recommended)

```cmd
# Run as Administrator
choco install make
```

### Option 2: MSYS2

```cmd
# Download from https://www.msys2.org/
# Install, then in MSYS2 terminal:
pacman -S make
# Add to PATH: C:\msys64\usr\bin
```

### Option 3: Manual Download

1. Download `make.exe` from [ezwinports](https://sourceforge.net/projects/ezwinports/)
2. Extract to `C:\Program Files\make\`
3. Add to system PATH

## ⚙️ Configuration

### Environment Variables (.env file)

Create `.env` in your project root:

```batch
REM .env file - NEVER commit this!
REM Registry Configuration
REGISTRY=docker.io
REGISTRY_NAMESPACE=myusername
IMAGE_TAG=latest

REM Database Configuration
DB_NAME=myapp
DB_USER=postgres
DB_PASSWORD=secretpassword

REM Application Configuration
APP_PORT=3000
NODE_ENV=development
```

### Configuration Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `REGISTRY` | `docker.io` | Container registry |
| `REGISTRY_NAMESPACE` | `%USERNAME%` | Your registry username |
| `IMAGE_NAME` | `demo-app` | Image name |
| `IMAGE_TAG` | `latest` | Image tag |
| `COMPOSE_FILE` | `docker-compose.yml` | Main compose file |
| `COMPOSE_DEV` | `docker-compose.override.yml` | Dev overrides |
| `COMPOSE_PROD` | `docker-compose.prod.yml` | Production file |

## 📚 Commands Reference

### Basic Commands

| Command | Description |
|---------|-------------|
| `make` or `make info` | Show project information |
| `make help` | Show all commands (if defined) |

### Building

| Command | Description |
|---------|-------------|
| `make build` | Build all images |
| `make build-no-cache` | Build without cache |
| `make build-service SERVICE=name` | Build specific service |

### Development

| Command | Description |
|---------|-------------|
| `make up` | Start services (detached) |
| `make up-dev` | Start with dev overrides |
| `make down` | Stop services |
| `make down-volumes` | Stop and delete volumes |
| `make restart` | Restart all services |
| `make logs` | View all logs (follow) |
| `make logs-service SERVICE=name` | View service logs |
| `make ps` | Show service status |
| `make shell SERVICE=name` | Open CMD in container |
| `make exec SERVICE=name CMD="command"` | Run command in container |

### Registry Operations

| Command | Description |
|---------|-------------|
| `make login` | Login to registry |
| `make logout` | Logout from registry |
| `make tag` | Tag image for registry |
| `make push` | Push image to registry |
| `make pull` | Pull image from registry |

### Cleanup

| Command | Description |
|---------|-------------|
| `make clean` | Remove stopped containers & unused images |
| `make clean-all` | Deep clean (all unused resources) |

### Utilities

| Command | Description |
|---------|-------------|
| `make setup-env` | Create .env file |
| `make info` | Show configuration |

## 💡 Usage Examples

### Example 1: Basic Development Workflow

```cmd
REM First time setup
make setup-env
make build
make up

REM During development
make logs                    REM Watch logs
make ps                      REM Check status
make shell SERVICE=api       REM Debug inside container

REM After code changes (with volume mounts)
make restart                 REM Restart services

REM End of day
make down
```

### Example 2: Working with Multiple Services

```cmd
REM Build specific service only
make build-service SERVICE=api

REM Start specific services manually
docker compose up -d api postgres

REM View logs for specific service
make logs-service SERVICE=api

REM Run migrations
make exec SERVICE=api CMD="npm run migrate"

REM Open shell in worker service
make shell SERVICE=worker
```

### Example 3: Build and Push to Registry

```cmd
REM Login to Docker Hub
make login

REM Build with version tag
make build IMAGE_TAG=v1.0.0

REM Push to registry
make push IMAGE_TAG=v1.0.0

REM Verify
docker pull myusername/myapp:v1.0.0
```

### Example 4: Production Deployment

```cmd
REM Build production image
make build IMAGE_TAG=production

REM Push to registry
make push IMAGE_TAG=production

REM On production server (Windows Server)
git pull
make pull IMAGE_TAG=production
docker compose -f docker-compose.prod.yml up -d
```

### Example 5: Testing Workflow

```cmd
REM Run tests
make exec SERVICE=test CMD="npm test"

REM Run with specific environment
make exec SERVICE=api CMD="npm run test:integration"

REM Clean and retest
make clean
make build
make exec SERVICE=test CMD="npm test"
```

## 🔄 Workflows

### Daily Development Flow

```cmd
REM 9:00 AM - Start day
cd C:\projects\myapp
git pull
make build
make up-dev
make logs

REM 12:00 PM - After coding
make exec SERVICE=api CMD="npm run lint"
make exec SERVICE=api CMD="npm test"

REM 5:00 PM - End day
make down
git add .
git commit -m "Daily work"
git push
```

### Release Flow

```cmd
REM Create release
set VERSION=v1.2.3
make build IMAGE_TAG=%VERSION%
make push IMAGE_TAG=%VERSION%

REM Deploy to staging
make pull IMAGE_TAG=%VERSION% (on staging server)
docker compose -f docker-compose.prod.yml up -d

REM Deploy to production (after testing)
make pull IMAGE_TAG=%VERSION% (on production server)
docker compose -f docker-compose.prod.yml up -d
```

### Emergency Rollback

```cmd
REM On production server
make pull IMAGE_TAG=v1.2.2
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d
```

## 🔌 Registry Setup

### Docker Hub

```cmd
make login REGISTRY=docker.io
REM Username: your Docker Hub username
REM Password: your Docker Hub password or access token
```

### GitHub Container Registry (GHCR)

```cmd
make login REGISTRY=ghcr.io
REM Username: your GitHub username
REM Password: GitHub personal access token (with packages:write)
```

### Private Registry

```cmd
make login REGISTRY=registry.yourcompany.com
REM Use your registry credentials
```

### Using Access Tokens (Recommended)

```cmd
REM Create token at hub.docker.com/settings/security
echo %DOCKER_TOKEN% | docker login --username %USERNAME% --password-stdin
```

## 📁 Docker Compose Examples

### Basic docker-compose.yml

```yaml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    image: demo-app:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DB_HOST=postgres
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - postgres
    networks:
      - app-network

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - app-network

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

### docker-compose.override.yml (Development)

```yaml
version: '3.8'

services:
  api:
    environment:
      - NODE_ENV=development
      - DEBUG=true
    command: npm run dev
    volumes:
      - .:/app
      - /app/node_modules
```

### docker-compose.prod.yml (Production)

```yaml
version: '3.8'

services:
  api:
    image: ${REGISTRY}/${REGISTRY_NAMESPACE}/demo-app:${IMAGE_TAG}
    ports:
      - "80:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 512M

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. **"make is not recognized"**

```cmd
REM Make not installed. Install via Chocolatey:
choco install make

REM Or add make.exe to PATH manually
setx PATH "%PATH%;C:\tools\make\bin"
```

#### 2. **"Docker is not running"**

```cmd
REM Start Docker Desktop manually
"C:\Program Files\Docker\Docker\Docker Desktop.exe"

REM Or restart Docker service
net stop com.docker.service
net start com.docker.service
```

#### 3. **"Access denied" when using volumes on Windows**

```cmd
REM Enable shared drives in Docker Desktop
REM Settings -> Resources -> File Sharing
REM Add your project drive (C:\, D:\, etc.)

REM Or use relative paths in docker-compose.yml
volumes:
  - ./src:/app/src  # Works on Windows
```

#### 4. **Port already in use**

```cmd
REM Find process using port
netstat -ano | findstr :3000
taskkill /PID <PID> /F

REM Or change port in docker-compose.yml
ports:
  - "3001:3000"
```

#### 5. **Build fails with "no space left"**

```cmd
REM Clean Docker resources
make clean-all

REM Check disk usage
docker system df

REM Move Docker data to another drive
REM Settings -> Resources -> Disk image location
```

#### 6. **Line ending issues (CRLF vs LF)**

```cmd
REM Convert Makefile to Windows line endings
powershell -Command "(Get-Content Makefile) -join \"`r`n\" | Set-Content Makefile"

REM Or in Git:
git config --global core.autocrlf true
```

#### 7. **Registry push fails**

```cmd
REM Check authentication
docker logout
make login

REM Verify image exists
docker images | findstr %IMAGE_NAME%

REM Retag if needed
docker tag myapp:latest myusername/myapp:latest
```

### Debug Mode

```cmd
REM See what commands would run
make -n build

REM Verbose output
make -d up

REM Continue on errors
make -i build
```

## 📝 Best Practices

### 1. **Always Use .env for Secrets**

```cmd
REM .gitignore
echo .env >> .gitignore
echo *.key >> .gitignore
echo *.pem >> .gitignore

REM Never commit secrets
git add .env  # DON'T DO THIS!
```

### 2. **Volume Mounting on Windows**

```yaml
# Good - relative paths
volumes:
  - ./src:/app/src
  - ./data:/app/data

# Bad - absolute paths (may fail)
volumes:
  - C:\Users\user\project:/app
```

### 3. **Use Consistent Line Endings**

```cmd
# Configure Git for Windows
git config --global core.autocrlf true

# Convert existing files
dos2unix Makefile  # If you have dos2unix
# Or save with CRLF in your editor
```

### 4. **Regular Cleanup**

```cmd
# Add to weekly schedule
schtasks /create /tn "DockerCleanup" /tr "make clean" /sc weekly /d SUN
```

### 5. **Resource Limits**

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
```

## 🔄 Migrating from Linux/Mac

### Key Differences

| Linux/Mac Command | Windows Command |
|-------------------|-----------------|
| `make up` | `make up` (same) |
| `make shell SERVICE=api` | `make shell SERVICE=api` (opens cmd) |
| `export VAR=value` | `set VAR=value` |
| `./script.sh` | `script.bat` or `cmd /c script.bat` |
| `$(VAR)` | `%VAR%` |
| `if [ -f file ]` | `if exist file` |

### Converting Scripts

```batch
REM Linux script.sh
#!/bin/bash
echo "Starting..."
docker compose up -d

REM Windows script.bat
@echo off
echo Starting...
docker compose up -d
```

## ❓ FAQ

### Q: Do I need WSL2?
**A:** No! This Makefile works with native Windows Docker Desktop and CMD.

### Q: Can I use PowerShell instead?
**A:** Yes, but this Makefile is optimized for CMD. For PowerShell, change `SHELL := powershell.exe`.

### Q: How do I use with Windows Server?
**A:** Works the same! Install Docker EE for Windows Server and Make.

### Q: Why no colors in output?
**A:** CMD doesn't support ANSI colors. For colored output, use PowerShell or WSL.

### Q: Can I run this in CI/CD?
**A:** Yes! Works in GitHub Actions Windows runners, GitLab CI Windows runners, and Jenkins Windows agents.

### Q: How to handle paths with spaces?
**A:** Avoid spaces in project paths. Use `C:\projects\myapp` not `C:\My Projects\app`.

### Q: Can I use with Docker Compose V1?
**A:** Upgrade to Docker Compose V2 (comes with Docker Desktop). V1 uses `docker-compose` (with hyphen).

## 🚀 Quick Reference Card

```cmd
REM Most common commands
make info                     REM Show configuration
make build                    REM Build images
make up                       REM Start services
make logs                     REM View logs
make ps                       REM Check status
make shell SERVICE=api        REM Debug container
make exec SERVICE=api CMD="npm test"  REM Run command
make push                     REM Push to registry
make down                     REM Stop services
make clean                    REM Clean up
```

## 📚 Additional Resources

- [Docker Documentation for Windows](https://docs.docker.com/desktop/windows/)
- [GNU Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)

## 🤝 Contributing

1. Fork the repository
2. Test your changes on Windows CMD
3. Ensure all commands work without WSL
4. Submit a pull request

## 📄 License

MIT License - Free for personal and commercial use

---

**Made for Windows Docker Developers** 🐳

Questions? Issues? Check the [Troubleshooting](#troubleshooting) section first!