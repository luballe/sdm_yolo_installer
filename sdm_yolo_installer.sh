#!/bin/bash

# Tasks to do before rebooting
before_reboot(){
  date +"%Y-%m-%d_%T *** Setting up datetime..."
  cp /usr/share/zoneinfo/America/Bogota /etc/localtime
  date +"%Y-%m-%d_%T Datetime set up!"
  date +"%Y-%m-%d_%T *** Datetime set up!"

  # Update system
  date +"%Y-%m-%d_%T *** Updating system..."
  sudo apt -y update
  sudo apt -y upgrade
  date +"%Y-%m-%d_%T *** System updated!"

  # Install desktop environment
  date +"%Y-%m-%d_%T *** Installing desktop environment..."
  sudo apt -y install xfce4
  date +"%Y-%m-%d_%T *** Desktop environment installed!"

  # Install remote desktop server
  date +"%Y-%m-%d_%T *** Installing remote desktop server..."
  sudo apt -y install xrdp
  sudo systemctl enable xrdp
  echo xfce4-session >~/.xsession
  sudo service xrdp restart
  date +"%Y-%m-%d_%T *** Desktop server installed!"

  # Prerequisites
  date +"%Y-%m-%d_%T *** Installing gcc g++..."
  # gcc g++
  sudo apt -y install gcc g++
  date +"%Y-%m-%d_%T *** gcc g++ installed!"
  # Utils
  date +"%Y-%m-%d_%T *** Installing zip unzip cmake iotop keychain..."
  sudo apt -y install zip
  sudo apt -y install unzip
  sudo apt -y install cmake
  sudo apt -y install iotop
  sudo apt -y install keychain
  date +"%Y-%m-%d_%T *** zip unzip cmake iotop keychain installed!"
  # FFMPEG
  date +"%Y-%m-%d_%T *** Installing ffmpeg..."
  sudo apt -y install ffmpeg
  date +"%Y-%m-%d_%T *** ffmpeg installed!"
  # Python
  date +"%Y-%m-%d_%T *** Installing python numpy..."
  sudo apt -y install python-dev python-numpy
  sudo apt -y install python3-dev python3-numpy
  date +"%Y-%m-%d_%T *** python numpy installed!"
  # GTK support for GUI features
  date +"%Y-%m-%d_%T *** Installing libavcodec libgstreamer..."
  sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev
  sudo apt -y install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
  date +"%Y-%m-%d_%T *** libavcodec libgstreamer installed!"
  # Support for gtk2 OpenCV:
  date +"%Y-%m-%d_%T *** Installing libgtk2..."
  sudo apt -y install libgtk2.0-dev
  date +"%Y-%m-%d_%T *** Installing libgtk2 installed!"
  # Support for gtk3 OpenCV:
  date +"%Y-%m-%d_%T *** Installing libgtk3..."
  sudo apt -y install libgtk-3-dev
  date +"%Y-%m-%d_%T *** libgtk3 installed!"
  # Optional dependencies for OpenCV
  date +"%Y-%m-%d_%T *** Installing OpenCV dependencies..."
  sudo apt -y install libpng-dev
  sudo apt -y install libjpeg-dev
  sudo apt -y install libopenexr-dev
  sudo apt -y install libtiff-dev
  sudo apt -y install libwebp-dev
  date +"%Y-%m-%d_%T *** OpenCV dependencies installed!"
  # TBB support for OpenCV
  date +"%Y-%m-%d_%T *** Installing TBB support for OpenCV..."
  sudo apt -y install libtbb-dev
  date +"%Y-%m-%d_%T *** TBB support for OpenCV installed!"
  # Install pip and tk
  date +"%Y-%m-%d_%T *** Installing pip tk..."
  sudo apt -y install python-pip
  sudo apt -y install python3-pip
  sudo apt -y install python-tk
  sudo apt -y install python3-tk 
  date +"%Y-%m-%d_%T *** pip tk installed!"
  # Install easyGui
  date +"%Y-%m-%d_%T *** Installing Easygui..."
  sudo -H pip install easygui
  date +"%Y-%m-%d_%T *** Easygui installed!"

  # Install Nvidia Driver
  date +"%Y-%m-%d_%T *** Downloading nvidia driver..."
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
  sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
  curl -L -o $cur_dir/cuda.deb http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
  date +"%Y-%m-%d_%T *** Nvidia driver downloaded!"
  date +"%Y-%m-%d_%T *** Unpacking nvidia driver..."
  sudo dpkg -i $cur_dir/cuda.deb
  date +"%Y-%m-%d_%T *** Nvidia driver unpackaged!"
  date +"%Y-%m-%d_%T *** Installing nvidia driver..."
  sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
  sudo apt -y update
  sudo apt -y install cuda
  date +"%Y-%m-%d_%T *** Nvidia driver installed!"

  date +"%Y-%m-%d_%T *** Testing nvidia GPU..."
  nvidia-smi
  date +"%Y-%m-%d_%T *** Nvidia GPU tested!"

  date +"%Y-%m-%d_%T *** Downloading OpenCV..."
  curl -L -o $cur_dir/opencv.zip https://github.com/opencv/opencv/archive/2.4.13.6.zip
  unzip -o $cur_dir/opencv.zip
  date +"%Y-%m-%d_%T *** OpenCV downoaded!"

  date +"%Y-%m-%d_%T *** Downloading sdm-yolo..."
  cd $cur_dir
  git clone https://github.com/calderonf/sdm_yolo.git
  date +"%Y-%m-%d_%T *** sdm-yolo downloaded!"

  date +"%Y-%m-%d_%T *** Downloading and unziping weights..."
  # Download utility for downloading google drive link
  curl -L -o $cur_dir/gdrive.sh https://raw.githubusercontent.com/luballe/gdrive.sh/master/gdrive.sh
  # Download zip file
  curl gdrive.sh | bash -s https://drive.google.com/file/d/1TnmqD8zmfnW0Vn9hylgEY33r4lCxU1jH
  unzip -o $cur_dir/weights.zip
  date +"%Y-%m-%d_%T *** weights downloaded and unzipped!"

  # Export Path
  date +"%Y-%m-%d_%T *** Exporting Path..."
  var='export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}'
  # | grep '\$' is for not expanding variable $var
  echo "$var" | grep '\$' >> $cur_dir/.bashrc
  date +"%Y-%m-%d_%T *** Path exported!"
  date +"%Y-%m-%d_%T *** Changing Ownership..."
  cd $cur_dir
  chown administrador:administrador $cur_dir/cuda.deb
  chown administrador:administrador $cur_dir/opencv.zip
  chown administrador:administrador $cur_dir/weights.zip
  chown administrador:administrador $cur_dir/weights
  chown administrador:administrador gdrive.sh
  chown administrador:administrador $cur_dir/.wget-hsts
  chown administrador:administrador $cur_dir/.xsession
  chown -R administrador:administrador $cur_dir/sdm_yolo
  chown -R administrador:administrador $cur_dir/weights
  chown -R administrador:administrador $cur_dir/opencv-2.4.13.6
  date +"%Y-%m-%d_%T *** Ownership changed!"
}

# Tasks to do after rebooting
after_reboot(){
  date +"%Y-%m-%d_%T *** Current directory: "$cur_dir

  date +"%Y-%m-%d_%T *** Compiling OpenCV..."
  cd $cur_dir
  mkdir -p $cur_dir/opencv-2.4.13.6/build
  cd opencv-2.4.13.6/build
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON -D WITH_CUDA=OFF -D WITH_OPENCL=OFF -D CMAKE_INSTALL_PREFIX=/usr/local ..
  make -j6
  date +"%Y-%m-%d_%T *** OpenCV Compiled!"
  date +"%Y-%m-%d_%T *** Installing OpenCV..."
  make install
  date +"%Y-%m-%d_%T *** OpenCV Installed!"

  date +"%Y-%m-%d_%T *** Compiling sdm_yolo..."
  cd $cur_dir/sdm_yolo
  make -j6
  date +"%Y-%m-%d_%T *** sdm_yolo compiled!"

  date +"%Y-%m-%d_%T *** Cleaning up..."
  rm $cur_dir/cuda.deb
  rm $cur_dir/opencv.zip
  rm $cur_dir/weights.zip
  rm $cur_dir/opencv-2.4.13.6 -rf
  date +"%Y-%m-%d_%T *** Clean Up!"
}

run(){
  date +"%Y-%m-%d_%T ver 0.1"
  
  date +"%Y-%m-%d_%T *** Setting up installation directory..."
  cur_dir=$(pwd)
  date +"%Y-%m-%d_%T *** Current directory: "$cur_dir

  if [ ! -f $cur_dir/resume-after-reboot ]; then
    #Am I running as root?
    date +"%Y-%m-%d_%T *** Checking if am I root..."
    if [ "$EUID" -ne 0 ]; then 
      date +"%Y-%m-%d_%T Execute as root!: sudo ./sdm_yolo_installer.sh"
      exit
    fi
    
    date +"%Y-%m-%d_%T *** I'm running as root!"
    date +"%Y-%m-%d_%T running script for the first time..."
    #before_reboot
    # Preparation for reboot
    script="bash "$cur_dir"/run.sh"
    # add this script to bashrc so it gets triggered immediately after reboot
    echo "$script" >> $cur_dir/.bashrc 
    # create a flag file to check if we are resuming from reboot.
    touch $cur_dir/resume-after-reboot
    chown administrador:administrador $cur_dir/resume-after-reboot
    date +"%Y-%m-%d_%T rebooting in 5 secs..."
    sleep 5
    #sudo reboot
  else
    date +"%Y-%m-%d_%T resuming script after reboot..."
    # Remove the line that we added in zshrc
    sed -i '/bash/d' $cur_dir/.bashrc 
    # remove the temporary file that we created to check for reboot
    rm -f $cur_dir/resume-after-reboot
    #after_reboot
    date +"%Y-%m-%d_%T *** Done! ***"
  fi
}

#run # 2>&1| tee 1>$cur_dir/log.txt
run > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)

