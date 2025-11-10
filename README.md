# Quarkus Demo Application

This is a sample Quarkus application configured for GitOps deployment with ArgoCD.

## Features

- RESTful API endpoints
- Health checks (SmallRye Health)
- Environment-aware configuration
- Ready for containerization
- GitOps-ready with Kubernetes manifests

## Endpoints

- `GET /greeting` - Returns a greeting message
- `GET /greeting/info` - Returns application information (JSON)
- `GET /health` - Health check endpoints
- `GET /health/ready` - Readiness probe
- `GET /health/live` - Liveness probe

## Running the application locally

```bash
./mvnw compile quarkus:dev
```

## Building the application

```bash
./mvnw package
```

## Building the Docker image

```bash
docker build -f Dockerfile -t quarkus-demo:latest .
```

## Configuration

The application can be configured through environment variables:

- `GREETING_MESSAGE` - Custom greeting message
- `APP_ENVIRONMENT` - Environment name (dev, staging, prod)

## Health Checks

The application includes SmallRye Health checks:
- Liveness: `/health/live`
- Readiness: `/health/ready`
