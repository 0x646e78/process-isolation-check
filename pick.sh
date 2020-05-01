#!/usr/bin/env bash

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
  printf "\nSELINUX:\t\t%s" "$selinux"
else
  printf "\nSELinux:\t\tNot Present"
fi

if [ -x "$(command -v aa-status)" ]; then
  apparmor=$(aa-status)
  printf "\nAppArmor:\t\t%s" "$apparmor"
else
  printf "\nAppArmor:\t\tNot Present"
fi

echo
echo
echo "=== PROCESS ${pid} ==="

if [[ "$(readlink /proc/92019/root)" == "/" ]]; then
  printf "CHROOT:\t\t\tNo"
else
  printf "CHROOT:\t\t\tYes"
fi

user=$(stat -c "%u" /proc/"$pid"/)
printf "\nPROCESS UID:\t\t%s" "$user"

group=$(stat -c "%g" /proc/"$pid"/)
printf "\nPROCESS GID:\t\t%s" "$group"

seccomp=$(grep Seccomp /proc/"$pid"/status | cut -f2)
case $seccomp in
  0)
    printf "\nSECCOMP:\t\tDisabled"
    ;;
  1)
    printf "\nSECCOMP:\t\tStrict"
    ;;
  2)
    printf "\nSECCOMP:\t\tFilter"
    ;;
esac

# shellcheck disable=SC2009
selinux_context=$(ps -eZ | grep "$pid" | cut -d" " -f1)
printf "\nSELINUX CONTEXT:\t%s" "$selinux_context"

echo 
echo

capabilities=$(getpcaps "$pid")
echo "$capabilities"
