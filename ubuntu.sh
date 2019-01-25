#!/bin/sh

echo -e "Installation script for Docker CE and nvidia-docker on Ubuntu 16+"

echo -e "Set non-interactive frontend"
echo -e "Script will run without any prompts"
export DEBIAN_FRONTEND=noninteractive

echo -e "\n###\n"
echo -e "Installing prerequisites for Docker CE"
echo -e "\n###\n"

apt-get update
apt-get remove docker docker-engine docker.io -y
apt-get install -y \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo -e "\n###\n"
echo -e "Installing Docker CE"
echo -e "Version: 18.06.1 (Kubernetes-compatible)"
echo -e "\n###\n"

apt-get update
apt-get install docker-ce=18.06.1~ce~3-0~ubuntu -y

echo -e "\n###\n"
echo -e "Installing NVIDIA drivers and CUDA"
echo -e "Driver version: 410.79"
echo -e "CUDA version: 10.0.130-1"
echo -e "\n###\n"

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb

dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

apt-get update
apt-get install cuda -y

echo -e "\n###\n"
echo -e "Installing nvidia-docker"
echo -e "Version: Version: 18.06.1 (Kubernetes-compatible)"
echo -e "\n###\n"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

distribution=$(. /etc/os-release;echo -e $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install nvidia-docker2=2.0.3+docker18.06.1-1 nvidia-container-runtime=2.0.0+docker18.06.1-1 -y

echo -e "\nInstalled nvidia-docker\n"

echo -e "\n###\n"
echo -e "Finished with no errors."
echo -e "\n\n[  TIP  ]\nDon't want to run Docker with sudo?"
echo -e "Add your own user by running 'usermod -aG docker \$USER' normally"
echo -e "\n\nSystem will now reboot!"
echo -e "\n###\n"

reboot
