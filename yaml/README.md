# 📦 Kubernetes Full-Stack Deployment

This repository contains Kubernetes manifests to deploy a full-stack application with separate frontend and backend services.

---

## 🛠 Prerequisites

Before you begin, ensure you have the following installed and configured:

- ✅ A running Kubernetes cluster (e.g., Minikube, Kind, EKS)
- ✅ `kubectl` CLI configured to access your cluster
- ✅ Docker images for both frontend and backend (either public or accessible from your cluster)

---

## 🚀 Deployment Steps

### 1. Apply All Manifests

Run the following command from the root directory containing your YAML files:

```bash
kubectl apply -f .
```

This will create all necessary deployments, services, and other Kubernetes resources.

---

### 2. Port-Forward Services

#### 🔹 Frontend Service

Expose the frontend service on your local machine:

```bash
kubectl port-forward svc/frontend-svc 8088:8088
```

Access the frontend at: [http://localhost:8088](http://localhost:8088)

#### 🔹 Backend Service

> ⚠️ Note: The port `808080` is invalid (Kubernetes supports ports up to 65535). You likely meant `8080:8080`.

Corrected command:

```bash
kubectl port-forward svc/backend-svc 8080:8080
```

Access the backend API at: [http://localhost:8080](http://localhost:8080)

---

## 📌 Notes

- Ensure your service definitions (`frontend-svc`, `backend-svc`) match the names used in your YAML files.
- If using Ingress or LoadBalancer in production, port-forwarding is only for local testing.
- You can verify pods and services using:

```bash
kubectl get pods
kubectl get svc
```

---

## 🤝 Contributing

Feel free to fork this repo, submit issues, or open pull requests to improve the deployment setup.

---

## 📬 Contact

Maintainer: **PRASAD C ZUNGARE**  
Role: DevOps Engineer   
Location: Pune

