if [ ! -e /usr/local/bin/kubectl ]
then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin
fi

if [ ! -e /usr/local/bin/k3d ]
then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

if [ ! -e /usr/local/bin/argocd ]
then
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
fi

# --subnet "172.20.0.0/16"
# k3d cluster create pgoudet --api-port 127.0.0.1:6445  --port '8080:80@loadbalancer'  --k3s-arg="--disable=traefik@server:0"
k3d cluster create pgoudet --port 8080:80@loadbalancer --port 8443:443@loadbalancer --port 8888:8888@loadbalancer --subnet "172.20.0.0/16"

READY=$(kubectl get deployment metrics-server -n kube-system)
READY=${READY:71:1}
echo "metrics-server status READY = $READY\n"
while [ $READY -eq 0 ]
do
    sleep 1
done

kubectl create namespace argocd

kubectl apply -f argocd.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl apply -f ingress.yaml -n argocd
PASS=$(argocd admin initial-password -n argocd)
PASS=${PASS%%" "*}
argocd login 172.20.0.3 --username admin --password $PASS --insecure 
argocd account update-password --account admin --current-password $PASS --new-password "Thepassw0rd"
CLUSTER=$(kubectl config get-contexts -o name)
argocd cluster add $CLUSTER -y

kubectl create namespace dev

kubectl config set-context --current --namespace=argocd
argocd app create willsapp --repo https://github.com/pgoudet-42/pgoudet-willsapp.git --path app --dest-server https://kubernetes.default.svc --dest-namespace dev --sync-policy auto


