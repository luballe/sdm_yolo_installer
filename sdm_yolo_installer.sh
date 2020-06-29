#!/bin/bash

# Tasks to do before rebooting
before_reboot(){

    date +"%R *** Setting up datetime..."
    cp /usr/share/zoneinfo/America/Bogota /etc/localtime
    date +"%R Datetime set up!"
    date +"%R *** Datetime set up!"

    # Update system
    date +"%R *** Updating system..."
    sudo apt -y update
    sudo apt -y upgrade
    date +"%R *** System updated!"

    # Install desktop environment
    date +"%R *** Installing desktop environment..."
    sudo apt -y install xfce4
    date +"%R *** Desktop environment installed!"

    # Install remote desktop server
    date +"%R *** Installing remote desktop server..."
    sudo apt -y install xrdp
    sudo systemctl enable xrdp
    echo xfce4-session >~/.xsession
    sudo service xrdp restart
    date +"%R *** Desktop server installed!"

    # Prerequisites
    date +"%R *** Installing gcc g++..."
    # gcc g++
    sudo apt -y install gcc g++
    date +"%R *** gcc g++ installed!"
    # Utils
    date +"%R *** Installing zip unzip cmake iotop keychain..."
    sudo apt -y install zip
    sudo apt -y install unzip
    sudo apt -y install cmake
    sudo apt -y install iotop
    sudo apt -y install keychain
    date +"%R *** zip unzip cmake iotop keychain installed!"
    # FFMPEG
    date +"%R *** Installing ffmpeg..."
    sudo apt -y install ffmpeg
    date +"%R *** ffmpeg installed!"
    # Python
    date +"%R *** Installing python numpy..."
    sudo apt -y install python-dev python-numpy
    sudo apt -y install python3-dev python3-numpy
    date +"%R *** python numpy installed!"
    # GTK support for GUI features
    date +"%R *** Installing libavcodec libgstreamer..."
    sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev
    sudo apt -y install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
    date +"%R *** libavcodec libgstreamer installed!"
    # Support for gtk2 OpenCV:
    date +"%R *** Installing libgtk2..."
    sudo apt -y install libgtk2.0-dev
    date +"%R *** Installing libgtk2 installed!"
    # Support for gtk3 OpenCV:
    date +"%R *** Installing libgtk3..."
    sudo apt -y install libgtk-3-dev
    date +"%R *** libgtk3 installed!"
    # Optional dependencies for OpenCV
    date +"%R *** Installing OpenCV dependencies..."
    sudo apt -y install libpng-dev
    sudo apt -y install libjpeg-dev
    sudo apt -y install libopenexr-dev
    sudo apt -y install libtiff-dev
    sudo apt -y install libwebp-dev
    date +"%R *** OpenCV dependencies installed!"
    # TBB support for OpenCV
    date +"%R *** Installing TBB support for OpenCV..."
    sudo apt -y install libtbb-dev
    date +"%R *** TBB support for OpenCV installed!"
    # Install pip and tk
    date +"%R *** Installing pip tk..."
    sudo apt -y install python-pip
    sudo apt -y install python3-pip
    sudo apt -y install python-tk
    sudo apt -y install python3-tk 
    date +"%R *** pip tk installed!"
    # Install easyGui
    date +"%R *** Installing Easygui..."
    sudo -H pip install easygui
    date +"%R *** Easygui installed!"

    # Install Nvidia Driver
    date +"%R *** Installing nvidia driver..."
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb -O $cur_dir/cuda.deb
    sudo dpkg -i $cur_dir/cuda.deb
    sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
    sudo apt -y update
    sudo apt -y install cuda
    date +"%R *** Nvidia driver installed!"

    date +"%R *** Testing nvidia GPU..."
    nvidia-smi
    date +"%R *** Nvidia GPU tested!"

    date +"%R *** Downloading OpenCV..."
    wget https://github.com/opencv/opencv/archive/2.4.13.6.zip -O $cur_dir/opencv.zip
    unzip $cur_dir/opencv.zip
    date +"%R *** OpenCV downoaded!"

    date +"%R *** Compiling OpenCV..."
    mkdir -p $cur_dir/opencv-2.4.13.6/build
    cd opencv-2.4.13.6/build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON -D WITH_CUDA=OFF -D WITH_OPENCL=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..
    make -j6
    date +"%R *** OpenCV Compiled!"
    date +"%R *** Installing OpenCV..."
    make install
    date +"%R *** OpenCV Installed!"

    date +"%R *** Downloading sdm-yolo..."
    cd $cur_dir
    git clone https://github.com/calderonf/sdm_yolo.git
    date +"%R *** sdm-yolo downloaded!"

    date +"%R *** Downloading and unzziping weights..."
    # Download utility for downloading google drive link
    wget https://raw.githubusercontent.com/luballe/gdrive.sh/master/gdrive.sh -O $cur_dir/gdrive.sh
    # Download zip file
    curl gdrive.sh | bash -s https://drive.google.com/file/d/1TnmqD8zmfnW0Vn9hylgEY33r4lCxU1jH
    unzip weights.zip
    date +"%R *** weihts downloaded and unzipped!"

    # Export Path
    date +"%R *** Exporting Path..."
    var='export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}'
    # | grep '\$' is for not expanding variable $var
    date +"%R $var" | grep '\$' >> $cur_dir/.bashrc
    date +"%R *** Path exported!"

# Tasks to do after rebooting
after_reboot(){
    date +"%R *** Compiling sdm_yolo..."
    cd $cur_dir/sdm_yolo
    make -j6
    date +"%R *** sdm_yolo compiled!"

    date +"%R *** Changing Ownership..."
    cd $cur_dir
    chown -R administrador:administrador .wget-hsts
    chown -R administrador:administrador .xsession
    chown -R administrador:administrador sdm_yolo
    chown -R administrador:administrador weights
    chown -R administrador:administrador gdrive.sh
    date +"%R *** Ownership changed!"

    date +"%R *** Cleaning up..."
    rm $cur_dir/cuda.deb
    rm $cur_dir/opencv.zip
    rm $cur_dir/weights.zip
    rm $cur_dir/opencv-2.4.13.6
    date +"%R *** Clean Up!"
}

#Flag to activate debug (sleep for x secs after each task executed)
DEBUG=1
# Secs to sleep after execute every task 
SLEEP_TIME=5
# FLag to activate logging
LOG=1

#Am I running as root?
date +"%R ver 0.1"
date +"%R *** Checking if am I root..."
if [ "$EUID" -ne 0 ] then 
  date +"%R Execute as root!: "
  date +"%R sudo ./sdm_yolo_installer.sh"
exit
fi

date +"%R *** I'm running as root!"

date +"%R *** Setting up installation directory..."
cur_dir=$(pwd)
date +"%R *** Current directory: "$cur_dir


if [ ! -f /var/run/resume-after-reboot ]; then
    date +"%R running script for the first time..."
    before_reboot
    # Preparation for reboot
    script="bash /sdm_yolo_installer.sh"
    # add this script to bashrc so it gets triggered immediately after reboot
    echo "$script" >> ~/.bashrc 
    # create a flag file to check if we are resuming from reboot.
    touch /var/run/resume-after-reboot
    date +"%R rebooting in 10 secs..."
    sleep 10
    sudo reboot
else
    date +"%R resuming script after reboot..."
    # Remove the line that we added in zshrc
    sed -i '/bash/d' ~/.bashrc 
    # remove the temporary file that we created to check for reboot
    rm -f /var/run/resume-after-reboot
    after_reboot
fi
