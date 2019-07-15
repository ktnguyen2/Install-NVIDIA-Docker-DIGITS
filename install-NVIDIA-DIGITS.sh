Reference link: 
## Install NVIDIA Drivers (refer to other script)

## Install CUDA Toolkit. Reference link: https://gist.github.com/zhanwenchen/e520767a409325d9961072f666815bb8
CUDA_REPO_PKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/${CUDA_REPO_PKG}
sudo dpkg -i ${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install cuda-9-0
# Check if CUDA is installed
nvcc -V

## Install cuDNN. Reference link for CUDA Toolkit includes instructions for installing cuDNN.
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.6.1.34/prod/9.0_20190620/cudnn-9.0-linux-x64-v7.6.1.34.tgz
tar -xzvf cudnn-9.0-linux-x64-v7.6.1.34.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

## Install Caffe. Reference link: https://chunml.github.io/ChunML.github.io/project/Installing-Caffe-Ubuntu/
sudo apt-get update
sudo apt-get upgrade
# Install necessary packages and libraries
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev \
libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler
sudo apt-get install -y --no-install-recommends libboost-all-dev
# Clone Caffe repo
git clone https://github.com/BVLC/caffe
cd caffe
# Create Makefile.config file
cp Makefile.config.example Makefile.config
# Apply modifications below. Refer to uploaded Makefile.config file.

# cuDNN acceleration switch (uncomment to build with cuDNN).
USE_CUDNN := 1

# Uncomment if you're using OpenCV 3
OPENCV_VERSION := 3

# We need to be able to find Python.h and numpy/arrayobject.h.
PYTHON_INCLUDE := /usr/include/python2.7 \
        /usr/local/lib/python2.7/dist-packages/numpy/core/include

# Uncomment to support layers written in Python (will link against    Python libs)
WITH_PYTHON_LAYER := 1

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial/

# For CUDA 9.0, remove the *_20 and *_21 lines for compatibility
CUDA_ARCH :=    -gencode arch=compute_30,code=sm_30 \
                -gencode arch=compute_35,code=sm_35 \
                -gencode arch=compute_50,code=sm_50 \
                -gencode arch=compute_52,code=sm_52 \
                -gencode arch=compute_60,code=sm_60 \
                -gencode arch=compute_61,code=sm_61 \
                -gencode arch=compute_61,code=compute_61

# Compile Caffe
make all
make test
make runtest
# If there is an error, you have to REMOVE BUILD before doing make command: rm -rf ./build*/

# Build python wrapper
make pycaffe
sudo vim ~/.bashrc
export PYTHONPATH=home/nvidianav/caffe/python:$PYTHONPATH
source ~/.bashrc
# Check if you have things working properly:
python
>>> import caffe
>>>> 

## Install NVIDIA DIGITS
# Install dependencies
sudo apt-get install --no-install-recommends git graphviz gunicorn python-dev python-flask python-flaskext.wtf python-gevent python-h5py python-numpy python-pil python-protobuf python-scipy
# Install pip
sudo apt-get install python-pip
# Install DIGITS
DIGITS_HOME=~/digits
git clone https://github.com/NVIDIA/DIGITS.git $DIGITS_HOME
python -m pip install -r $DIGITS_HOME/requirements.txt
export CAFFE_HOME=/home/nvidianav/caffe
# Start DIGITS server
./digits-server
