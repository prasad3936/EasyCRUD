# 🛠️ EasyCRUD Kubernetes Deployment

This project sets up a simple full-stack CRUD application using Kubernetes. It includes three main components:

- 🌐 **Frontend** (served on port `8088`)
- ⚙️ **Backend API** (served on port `8080`)
- 🗄️ **Database** (internal service)

---

## 📦 Prerequisites

Make sure you have the following installed:

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- A running Kubernetes cluster (e.g., Minikube, Docker Desktop, or a cloud provider)

---

## 🚀 Deployment Steps

Apply the Kubernetes manifests in the following order:

```bash
kubectl apply -f db-deployment.yml
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
```

## Accessing Application 

Run the following commands:
```bash
# Forward frontend service to localhost:8088
kubectl port-forward svc/easycrud-frontend-service 8088:80

# Forward backend service to localhost:8080
kubectl port-forward svc/easycrud-backend-service 8080:8080
```

Open your browser and go to: http://localhost:8088

The frontend will communicate with the backend via the forwarded port.

## Clean Up
To delete the resources 

```bash
kubectl delete -f frontend-deployment.yml
kubectl delete -f backend-deployment.yml
kubectl delete -f db-deployment.yml
```



