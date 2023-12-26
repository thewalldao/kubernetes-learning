# Kubernetes Learning

[**Kubernetes Tutorial for Beginners [FULL COURSE in 4 Hours]**](https://www.youtube.com/watch?v=X48VuDVv0do&t=490s&ab_channel=TechWorldwithNana)\
[**TechWorld with Nana - Basic Kubernetes Demo**](https://gitlab.com/nanuchi/youtube-tutorial-series/-/tree/master)\
[**The Childrens Illustrated Guide To Kubernetes**](https://www.cncf.io/phippy/the-childrens-illustrated-guide-to-kubernetes/)

## What is Kubernetes?

- [**Kubernetes**](https://kubernetes.io/), also known as K8s, is an open-source system for automating deployment, scaling, and management of containerized applications.
- Developed by Google
- Helps you manage containeried applications in different deployment environments (physical, virtual, cloud, hybrid...)

### What problems does Kubernetes solve?

#### What are the tasks of an orchestration tool?

The need for a container orchestration tool

- Trend from [**Monolith**](https://microservices.io/patterns/monolithic.html) to [**Miroservices**](https://microservices.io/)
- Increased usage of [**Containers**](https://www.docker.com/resources/what-container/)
- Demand for a proper way of managing those hundreds of containers

#### What feature do orchestration tool offer?

- **High Availability** or no downtime
- **Scalability** or high performance
- **Disaster Recovery** - backup and restore

## K8s Components explained

https://kubernetes.io/docs/concepts/overview/components/
![components](components.png)

## Kubernetes setup (For Linux Arch based user)

https://wiki.archlinux.org/title/Kubernetes \
https://docs.tigera.io/calico/latest/getting-started/kubernetes/ \
https://blooprynt.io/blog/2018/11/12/start-to-finish-net-containers-deployed-in-on-premise-load-balanced-kubernetes-with-istio-mesh
https://kubernetes.github.io/ingress-nginx/deploy/baremetal/

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --cri-socket /run/containerd/containerd.sock \
sudo kubeadm init --pod-network-cidr=172.16.0.0/12 --apiserver-advertise-address 0.0.0.0 \
https://serverfault.com/questions/586714/nmap-find-free-ips-from-the-range \
nmap -v -sn -n 192.168.10.0/24 -oG - | awk '/Status: Down/{print $2}' \
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-
https://docs.google.com/spreadsheets/d/191WWNpjJ2za6-nbG4ZoUMXMpUK8KlCIosvQB0f-oq3k/edit#gid=907731238

https://github.com/derailed/k9s/issues/468 \
alias k9prod="k9s --context mycluster -n my
export EDITOR=nvim
export GIT_EDITOR=nvim
alias code=vscodium
source <(kubectl completion zsh)
https://gist.github.com/doevelopper/ff4a9a211e74f8a2d44eb4afb21f0a38 \
https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/kubectl/kubectl.plugin.zsh \
https://github.com/ohmyzsh/ohmyzsh/wiki \
sh -c "$(curl -fsSL https://install.ohmyz.sh)"

sh -c "$(wget -O- https://install.ohmyz.sh)"
KEY_FILE=argocd.example.com.key
CERT_FILE=argocd.example.com.crt
HOST=argocd.example.com

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}" -addext "subjectAltName = DNS:${HOST}”
https://kubernetes.github.io/ingress-nginx/user-guide/tls/
