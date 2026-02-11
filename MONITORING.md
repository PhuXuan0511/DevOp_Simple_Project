# Kubernetes Monitoring with Prometheus & Grafana

## Overview

This setup includes:
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboarding
- **Service Discovery**: Auto-discovery of pods with Prometheus scrape annotations

## Prerequisites

- Kubernetes cluster (1.16+)
- kubectl configured to access your cluster
- Helm (optional, for easier management)

## Quick Start

### 1. Deploy Prometheus & Grafana

Apply the monitoring stack to your cluster:

```bash
kubectl apply -f k8s/deployments.yaml
```

Verify the deployments:

```bash
kubectl get deployments
kubectl get services
kubectl get pods | grep -E "(prometheus|grafana)"
```

### 2. Access the Services

#### Option A: Port Forwarding (Local Development)

**Prometheus:**
```bash
kubectl port-forward svc/prometheus 9090:9090
# Access: http://localhost:9090
```

**Grafana:**
```bash
kubectl port-forward svc/grafana 3000:3000
# Access: http://localhost:3000
# Default credentials: admin / admin
```

#### Option B: Ingress (Production)

If your cluster has an Ingress Controller:
- Prometheus: `http://devop-simple.local/prometheus`
- Grafana: `http://devop-simple.local/grafana`

### 3. Configure Grafana

1. **Login to Grafana**
   - URL: http://localhost:3000
   - Username: `admin`
   - Password: `admin`
   - Change the password on first login

2. **Add Prometheus as Data Source**
   - The datasource should already be provisioned automatically
   - Navigate to Configuration > Data Sources
   - Verify Prometheus is connected

3. **Create Dashboards**

   **Option A: Import Pre-made Dashboards**
   - Go to Dashboards > Import
   - Use Grafana Dashboard ID: `3662` (Prometheus 2.0 Stats)
   - Or ID: `1860` (Node Exporter for Prometheus)

   **Option B: Create Custom Dashboards**
   - Click + > Dashboard > Add New Panel
   - Use PromQL queries:
   
   **Backend Metrics Example:**
   ```promql
   # Request Rate
   rate(http_requests_total[5m])
   
   # Error Rate
   rate(http_requests_total{status=~"5.."}[5m])
   ```

## Monitoring Your Applications

### Adding Metrics to Your Backend (FastAPI)

Add Prometheus metrics to your FastAPI application:

```bash
pip install prometheus-client
```

Update `backend/backend.py`:

```python
from fastapi import FastAPI
from prometheus_client import Counter, Histogram, make_wsgi_app
from prometheus_client.opentelemetry.metric_reader import PrometheusMetricReader
from prometheus_client import REGISTRY
from prometheus_client.core import CollectorRegistry
import os

app = FastAPI()

# Create metrics
http_requests_total = Counter(
    'http_requests_total',
    'Total HTTP Requests',
    ['method', 'endpoint', 'status']
)

http_request_duration = Histogram(
    'http_request_duration_seconds',
    'HTTP Request Duration',
    ['method', 'endpoint']
)

@app.get("/health")
def health():
    http_requests_total.labels(method='GET', endpoint='/health', status=200).inc()
    return {"status": "ok"}

@app.get("/version")
def version():
    http_requests_total.labels(method='GET', endpoint='/version', status=200).inc()
    return {"version": os.getenv("APP_VERSION", "dev")}

@app.get("/metrics")
def metrics():
    from prometheus_client import generate_latest
    return generate_latest(REGISTRY)
```

### Pod Annotations

The backend and frontend pods are configured with Prometheus scrape annotations:

```yaml
annotations:
  prometheus.io/scrape: "true"      # Enable scraping
  prometheus.io/port: "8000"        # Port to scrape
  prometheus.io/path: "/metrics"    # Metrics endpoint
```

## Prometheus Configuration

The scrape configuration automatically discovers:
- All pods with `prometheus.io/scrape: "true"` annotation
- Uses the port specified in `prometheus.io/port`
- Uses the path specified in `prometheus.io/path`

View the configuration:
```bash
kubectl get configmap prometheus-config -o yaml
```

## Useful PromQL Queries

```promql
# CPU usage
container_cpu_usage_seconds_total

# Memory usage
container_memory_usage_bytes

# Pod restart count
kube_pod_container_status_restarts_total

# Pod up/down status
kube_pod_status_phase{phase="Running"}

# API request rate
rate(http_requests_total[5m])

# API error rate
rate(http_requests_total{status=~"5.."}[5m])
```

## Backup and Persistence

Currently, Prometheus and Grafana use `emptyDir` volumes (temporary storage). For production:

1. **Create PersistentVolumes:**

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-storage-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-storage-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

2. Update the deployments to use these PVCs instead of `emptyDir`.

## Troubleshooting

### Prometheus not scraping metrics

1. Check if pods have correct annotations:
```bash
kubectl get pods -o yaml | grep prometheus.io
```

2. Check Prometheus targets:
```bash
kubectl port-forward svc/prometheus 9090:9090
# Visit http://localhost:9090/targets
```

3. Check logs:
```bash
kubectl logs -f deployment/prometheus
```

### Grafana datasource not connecting

1. Verify Prometheus is running:
```bash
kubectl port-forward svc/prometheus 9090:9090
```

2. Test connectivity from Grafana pod:
```bash
kubectl exec -it deployment/grafana -- curl http://prometheus:9090
```

3. Check Grafana logs:
```bash
kubectl logs -f deployment/grafana
```

## Next Steps

1. Enable authentication in Grafana for security
2. Set up alert rules in Prometheus
3. Configure persistent storage for production
4. Add more custom metrics to your applications
5. Export dashboards for version control
6. Integrate with your CI/CD pipeline for automated dashboard deployment

## References

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Kubernetes Monitoring Best Practices](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)
