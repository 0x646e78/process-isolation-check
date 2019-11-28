#!/usr/bin/bash

if [[ $# -ne 1 ]] ; then
  echo 'Specify the PID as argument'
  exit 1
fi

pid=$1

if ! [ -d "/proc/$pid" ]; then
  echo "Process of PID $pid not found"
  exit 1
fi

echo "=== SYSTEM ==="

active_lsm=$(cat /sys/kernel/security/lsm)
printf "ACTIVE LSM MODULES:\t%s" "$active_lsm"

if [ -x "$(command -v getenforce)" ]; then
  selinux=$(getenforce)
  if [[ "$selinux" == "Disabled" ]]; then
    printf "\nSELINUX:\t\tDISABLED"
  elif [[ "$selinux" == "Permissive" ]]; then
    printf "\nSELINUX:\t\tPERMISSIVE"
  elif [[ "$selinux" == "Enforced" ]]; then
    printf "\nSELINUX:\t\tENFORCED"
  fi
else
  printf "\nSELinux:\t\tNOT PRESENT"
fi

if [ -x "$(command -v aa-status)" ]; then
  apparmor=$(aa-status)
  echo "$apparmor"
else
  printf "\nAppArmor:\t\tNOT PRESENT"
fi

echo
echo
echo "=== PROCESS ${pid} ==="

user=$(stat -c "%u" /proc/"$pid"/)
printf "PROCESS UID:\t\t%s" "$user"

group=$(stat -c "%g" /proc/"$pid"/)
printf "\nPROCESS GID:\t\t%s" "$group"

seccomp=$(grep Seccomp /proc/"$pid"/status | cut -f2)
case $seccomp in
  0)
    printf "\nSECCOMP:\t\tDISABLED"
    ;;
  1)
    printf "\nSECCOMP:\t\tSTRICT"
    ;;
  2)
    printf "\nSECCOMP:\t\tFILTER"
    ;;
esac

# shellcheck disable=SC2009
selinux_context=$(ps -eZ | grep "$pid" | cut -d" " -f1)
printf "\nSELINUX CONTEXT:\t%s" "$selinux_context"

echo 
echo

capabilities=$(getpcaps "$pid")
echo "$capabilities"
