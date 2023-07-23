data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_network_interface" "interface" {
  subnet_id = var.aws_network_subnet_id
  security_groups = [aws_security_group.allow_tls.id]
}

resource "aws_instance" "ec2" {
  depends_on    = [aws_network_interface.interface]
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.aws_instance_type
  #user_data                  =   filebase64("./user_data.sh")
  #user_data_replace_on_change = true
  user_data = <<EOF
#!/bin/bash

#echo 'export PATH=$PATH:/usr/local/bin' >> /root/.bash_profile
#source /root/.bash_profile


##### JENKINS #######
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade -y
amazon-linux-extras install java-openjdk11 -y
yum install jenkins git -y

####### DOCKER ############
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker jenkins
systemctl enable jenkins
systemctl start jenkins

#### KUBECTLandHELM ######
curl -LO https://dl.k8s.io/release/v1.27.4/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.12.2

###### KIND ########
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

cat <<KINDEOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
    protocol: TCP
KINDEOF

/usr/local/bin/kubectl create secret docker-registry regcred   --docker-server=036104832939.dkr.ecr.eu-central-1.amazonaws.com   --docker-username=AWS   --docker-password=$(aws ecr get-login-password --region eu-central-1)
mkdir /var/lib/jenkins/.kube/
mv .kube/config /var/lib/jenkins/.kube
chown -R jenkins: /var/lib/jenkins/.kube

EOF

  iam_instance_profile = aws_iam_instance_profile.profile.name
  network_interface {
    network_interface_id = aws_network_interface.interface.id
    device_index         = 0
  }
  tags = {
    name = "Jenkins"
  }
}
