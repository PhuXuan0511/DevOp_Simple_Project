from fastapi import FastAPI, Request
from prometheus_client import Counter, Histogram, REGISTRY, generate_latest
import os
import time

app = FastAPI()

# Prometheus metrics
http_requests_total = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

http_request_duration_seconds = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['method', 'endpoint']
)

@app.middleware("http")
async def add_prometheus_metrics(request: Request, call_next):
    """Middleware to track all HTTP requests with Prometheus metrics"""
    start_time = time.time()
    
    response = await call_next(request)
    
    duration = time.time() - start_time
    
    # Record metrics
    http_requests_total.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).inc()
    
    http_request_duration_seconds.labels(
        method=request.method,
        endpoint=request.url.path
    ).observe(duration)
    
    return response

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/version")
def version():
    return {"version": os.getenv("APP_VERSION", "dev")}

@app.get("/metrics")
def metrics():
    """Prometheus metrics endpoint"""
    return generate_latest(REGISTRY)
