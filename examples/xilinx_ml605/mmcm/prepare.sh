#!/bin/bash

COREGEN=`which coregen`

if [[ $COREGEN ]]; then
   coregen -p resources/coregen.cgp -b resources/mmcm.xco
   git checkout resources/mmcm.xco
   rm coregen.log
else
   echo "ERROR: coregen not found."
   echo "Please prepare the environment running something like:"
   echo "$ . /PATH_TO_ISE/ISE_DS/settings64.sh"
   echo "Note: this design needs ISE Design Suite with support and a valid license for Virtex 6 LXT 240."
fi
