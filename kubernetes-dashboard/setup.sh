dashboardDomain=$1
mkdir $HOME/certs
openssl genrsa -out $HOME/certs/dashboard.key 2048
openssl rsa -in $HOME/certs/dashboard.key -out $HOME/certs/dashboard.key
openssl req -sha256 -new -key $HOME/certs/dashboard.key -out $HOME/certs/dashboard.csr -subj "/CN=${dashboardDomain}"
openssl x509 -req -sha256 -days 365 -in $HOME/certs/dashboard.csr -signkey $HOME/certs/dashboard.key -out $HOME/certs/dashboard.crt
kubectl create ns "kubernetes-dashboard"
kubectl -n kubernetes-dashboard create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs
kubectl apply -f recommended.yaml
kubectl -n kubernetes-dashboard get all
kubectl apply -f kubernetes-dashboard-in.yaml
kubectl apply -f dashboard-sa.yaml
kubectl apply -f dashboard-crb.yaml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
