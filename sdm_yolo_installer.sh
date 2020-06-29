#!/bin/bash
#Am I running as root?
echo "ver 0.1"
echo "*** Checking if am I root..."
if [ "$EUID" -ne 0 ]
  then echo "Execute as root!"
  exit
fi
echo "*** I'm root!"

echo "*** Setting up datetime.."
cp /usr/share/zoneinfo/America/Bogota /etc/localtime
echo "Datetime set up!"

echo "*** Setting up installation directory..."
cur_dir=$(pwd)
echo "*** Current directory: "$cur_dir

# Update system
echo "*** Updating system..."
sudo apt -y update
sudo apt -y upgrade

# Install desktop environment
echo "*** Installing desktop environment..."
sudo apt -y install xfce4

# Install remote desktop server
echo "*** Installing remote desktop server..."
sudo apt -y install xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart

# Prerequisites
echo "*** Installing gcc g++..."
# gcc g++
sudo apt -y install gcc g++
# Utils
echo "*** Installing zip unzip cmake iotop keychain..."
sudo apt -y install zip
sudo apt -y install unzip
sudo apt -y install cmake
sudo apt -y install iotop
sudo apt -y install keychain
# FFMPEG
echo "*** Installing ffmpeg..."
sudo apt -y install ffmpeg
# Python
echo "*** Installing python numpy..."
sudo apt -y install python-dev python-numpy
sudo apt -y install python3-dev python3-numpy
# GTK support for GUI features
echo "*** Installing libavcodec libgstreamer..."
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev
sudo apt -y install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
# Support for gtk2 OpenCV:
echo "*** Installing libgtk2..."
sudo apt -y install libgtk2.0-dev
# Support for gtk3 OpenCV:
echo "*** Installing libgtk3..."
sudo apt -y install libgtk-3-dev
# Optional dependencies for OpenCV
echo "*** Installing OpenCV dependencies..."
sudo apt -y install libpng-dev
sudo apt -y install libjpeg-dev
sudo apt -y install libopenexr-dev
sudo apt -y install libtiff-dev
sudo apt -y install libwebp-dev
# TBB support for OpenCV
echo "*** Installing TBB support for OpenCV..."
sudo apt -y install libtbb-dev
# Install pip and tk
echo "*** Installing pip tk..."
sudo apt -y install python-pip
sudo apt -y install python3-pip
sudo apt -y install python-tk
sudo apt -y install python3-tk 
# Install easyGui
echo "*** Installing Easygui..."
pip install easygui

# Install Nvidia Driver
echo "*** Installing nvidia driver..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt -y update
sudo apt -y install cuda

echo "*** Testing nvidia GPU..."
nvidia-smi

echo "*** Downloading OpenCV..."
wget https://github.com/opencv/opencv/archive/2.4.13.6.zip
unzip 2.4.13.6.zip

echo "*** Downloading sdm-yolo..."
git clone https://github.com/calderonf/sdm_yolo.git

echo "*** Downloading weights..."
# Download utility for downloading google drive link
wget https://raw.githubusercontent.com/luballe/gdrive.sh/master/gdrive.sh
# Download zip file
curl gdrive.sh | bash -s https://drive.google.com/file/d/1TnmqD8zmfnW0Vn9hylgEY33r4lCxU1jH
unzip weights.zip

# Export Path
echo "*** Exporting Path..."
var='export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}'
# | grep '\$' is for not expanding variable $var
echo "$var" | grep '\$' >> $cur_dir/.bashrc

echo "*** Compiling OpenCV..."
mkdir -p $cur_dir/opencv-2.4.13.6/build
cd opencv-2.4.13.6/build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON -D WITH_CUDA=OFF -D WITH_OPENCL=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j6
make install

echo "*** Compiling SDM_YOLO..."
cd $cur_dir/sdm_yolo
make -j6

echo "*** Changing Ownership..."
chown -R administrador:administrador sdm_yolo
chown -R administrador:administrador weights

echo "*** Cleaning..."
rm cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
rm 2.4.13.6.zip
rm weights.zip



