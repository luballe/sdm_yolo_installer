#!/bin/bash
#./sdm_yolo_installer.sh 2>&1| tee 1>$log.txt
./sdm_yolo_installer.sh > >(tee -a sdm_yolo_stdout.log) 2> >(tee -a sdm_yolo_stderr.log >&2)
