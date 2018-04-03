#!/bin/bash

# Function : Check scripts for Rainbond install
# Args     : Null
# Author   : zhouyq (zhouyq@goodrain.com)
# Version  :
# 2018.03.22 first release


# Function : Check internet
# Args     : Check url
# Return   : (0|!0)
Check_Internet(){
  check_url=$1
  curl -s --connect-timeout 3 $check_url -o /dev/null 2>/dev/null
  if [ $? -eq 0 ];then
    return 0
  else
    Echo_Error "Unable to connect to internet."
  fi
}


# Name   : check docker 
# Args   : NULL
# Return : 0|!0
Check_Docker(){
  if $(which docker >/dev/null 2>&1);then
    Echo_Error "Rainbond integrated customized docker, Please uninstall it first."
  else
    return 0
  fi
}


# Name   : Check_System_Version
# Args   : NULL
# Return : 0|!0
Check_System_Version(){
  case $SYS_NAME in
  "centos")
    [ "$SYS_VER" == "7" ] \
    && return 0 \
    || Echo_Error "$SYS_NAME:$SYS_VER is not supported temporarily."
    ;;
  "ubuntu")
    [ "$SYS_VER" == "16.04" ] \
    && return 0 \
    || Echo_Error "$SYS_NAME:$SYS_VER is not supported temporarily."
    ;;
  "debian")
    [ "$SYS_VER" == "8" -o "$SYS_VER" == "9" ] \
    && return 0 \
    || Echo_Error "$SYS_NAME:$SYS_VER is not supported temporarily."
    ;;
  *)
    Echo_Error "$SYS_NAME:$SYS_VER is not supported temporarily."
    ;;
  esac
}

# Name   : Get_Net_Info
# Args   : public_ips、public_ip、inet_ips、inet_ip、inet_size、
# Return : 0|!0
Check_Net(){

  for eth in $(ls -1 /sys/class/net|grep -v lo) ;do 
      ipaddr=$(ip addr show $eth | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}' )
      if [ "$SYS_NAME" == "centos"];then
        Check_net_card $NET_FILE/ifcfg-$eth $ipaddr
      else
        Check_net_card $NET_FILE $ipaddr
      fi
  done
}


# Name   : Get_Hardware_Info
# Args   : cpu_num、memory_size、disk
# Return : 0|!0
Get_Hardware_Info(){

    if [ $CPU_NUM -lt $CPU_LIMIT ] || [ $MEM_SIZE -lt $MEM_LIMIT ];then
      Echo_Error "We need $CPU_LIMIT CPUS,$MEM_LIMIT G Memories. You Have $CPU_NUM CPUS,$MEM_SIZE G Memories"
    fi
}



#=============== main ==============

[ ! -f "/usr/lib/python2.7/site-packages/sitecustomize.py" ] && (
    cp ./scripts/sitecustomize.py /usr/lib/python2.7/site-packages/sitecustomize.py
    Echo_Info "Configure python defaultencoding"
    Echo_Ok
)

Echo_Info "Checking internet connect ..."
Check_Internet $RAINBOND_HOMEPAGE && Echo_Ok

Echo_Info "Check system environment..."
Check_Docker && Echo_Ok

if [ "$1" != "force" ];then
  # disk cpu memory
  Echo_Info "Getting Hardware information ..."
  Get_Hardware_Info && Echo_Ok

  #ipaddr(inet pub) type .mark in .sls
  Echo_Info "Getting Network information ..."
  Check_Net && Echo_Ok
fi

