## Follow this link to install NVIDIA Drivers on Ubuntu. Easiest method is to use Software Manager.
# https://www.maketecheasier.com/install-nvidia-drivers-ubuntu/
# Using GeForce GTX 760, I installed NVIDIA binary driver 384.130 (proprietary)

## Install Docker
# Reference link with explanation of Docker and NVIDIA Docker: 
# https://chunml.github.io/ChunML.github.io/project/Installing-NVIDIA-Docker-On-Ubuntu-16.04/
# Remove old version of docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
# Install packages to allow apt to use repository through HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# Add the official GPG key of Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
# Install Docker CE
sudo apt-get install docker-ce
# Check if Docker is installed correctly
sudo docker run hello-world
# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

## Install NVIDIA Docker
# Remove NVIDIA docker 1.0
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker
# Add necessary repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
# Install NVIDIA docker
sudo apt-get install nvidia-docker2
sudo pkill -SIGHUP dockerd
# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

## Install TensorRT. Reference link: https://developer.download.nvidia.com/compute/machine-learning/tensorrt/secure/3.0/ga/TensorRT-Installation-Guide-3.0.4.pdf?K4zMZg2h8AJsRXkVqKnkWJ0tL4IdW5_czxEYNmbyBRyoklMbRpGvYF_uE28XeYPmyPw79OyUXZkVqCuVdu0qWLn8WuWxvMZo3Ky_YYnRfLHsrdZB26Bq7s_uVQRbqCEvM1wFlNZh8DadXe3lM-ndhUySBD4dKYI8xwm4Ckou2mCnge2Y6MbjWu9ONNSALem3nWNEMw
wget https://developer.nvidia.com/compute/machine-learning/tensorrt/3.0/ga/nv-tensorrt-repo-ubuntu1604-ga-cuda9.0-trt3.0.4-20180208_1-1_amd64-deb
sudo dpkg -i nv-tensorrt-repo-ubuntu1604-ga-cuda9.0-trt3.0.4-20180208_1-1_amd64.deb
sudo apt-get update
sudo apt-get install tensorrt
sudo apt-get install python-libnvinfer-doc
sudo apt-get install uff-converter-tf
