# 二进制部署K8S

本项目采用ansible进行kubernetes的二进制部署，帮助需要的伙伴快速部署一套生产可以用的kubernetes集群。

# 部署要求

1、3台及以上机器，操作系统CentOS(7以上版本)/Ubuntu(18以上版本)，配置好网络，主机名，SSH免密或SSH密码

2、下载kubernetes和containerd二进制安装文件（无法下载的下方有网盘链接）

# 部署步骤

1、在ansible节点上安装ansible和git

```
sudo apt install ansible git
git clone https://github.com/yxydde/ansible_k8s.git
```

2、解压安装包

```
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O cfssl
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O cfssljson
sudo mv cfssl /usr/local/bin/
sudo mv cfssljson /usr/local/bin/
sudo chmod u+x /usr/local/bin/cfssl
sudo chmod u+x /usr/local/bin/cfssljson

wget https://storage.googleapis.com/kubernetes-release/release/v1.27.2/kubernetes-server-linux-amd64.tar.gz
tar -xzf kubernetes-server-linux-amd64.tar.gz 
sudo mv kubernetes/server/bin/* /usr/local/bin/

wget https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz
tar -xzf etcd-v3.5.9-linux-amd64.tar.gz 
sudo mv etcd-v3.5.9-linux-amd64/{etcd,etcdctl} /usr/local/bin/

sudo mkdir /opt/pkgs/
sudo wget https://github.com/containerd/containerd/releases/download/v1.6.21/cri-containerd-1.6.21-linux-amd64.tar.gz -O /opt/pkgs

# 如果是centos 7需要单独下载 Static Linking 的 runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64
sudo mv runc.amd64 /usr/local/sbin/runc
sudo chmod u+x /usr/local/sbin/runc 
```

3、编辑主机文件(配置 etcd master node 个角色的主机)，规划网络

> 注意：k8s节点网络、service网络、Pod网络不可重叠

```
cd ansible_k8s
vi example/hosts.multi-node
```

4、执行ansible脚本进行部署

```
# 进行系统基本设置
ansible-playbook -i example/hosts.multi-node 01.prepare.yml
# 生成相关证书文件
ansible-playbook -i example/hosts.multi-node 02.cert.yml
# 部署 etcd 集群
ansible-playbook -i example/hosts.multi-node 03.etcd.yml
# 部署containerd
ansible-playbook -i example/hosts.multi-node 04.containerd.yml
# 部署 master 节点
ansible-playbook -i example/hosts.multi-node 05.kube-master.yml
# 部署 master 节点高可用代理（可选），默认使用本地代理
ansible-playbook -i example/hosts.multi-node 06.ext-lb.yml
# 部署客户端节点
ansible-playbook -i example/hosts.multi-node 07.kube-client.yml
# 部署node节点
ansible-playbook -i example/hosts.multi-node 08.kube-node.yml
# 部署 calico 网络插件（calico/flannel二选一即可）
ansible-playbook -i example/hosts.multi-node 09.kube-calico.yml
# 部署 flannel 网络插件 （calico/flannel二选一即可）
ansible-playbook -i example/hosts.multi-node 09.kube-flannel.yml
# 部署 coredns
ansible-playbook -i example/hosts.multi-node 10.coredns.yml
# 部署 metrics-server
ansible-playbook -i example/hosts.multi-node 11.metrics-server.yml
# 部署 ingress-nginx
ansible-playbook -i example/hosts.multi-node 12.ingress-nginx.yml
# 部署 dashboard（可选）
ansible-playbook -i example/hosts.multi-node 13.dashboard.yml
```

# 网盘地址

K8S二进制安装文件（如链接失效或密码不正确，可以 [微信](./微信.jpg) 联系，也欢迎微信交流）

链接：https://pan.baidu.com/s/1Mq6Wpu4-YE582jGNsF2cBQ 
提取码：cshx
