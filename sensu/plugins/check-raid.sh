#!/bin/bash

while getopts 'z' OPT; do
  case $OPT in
    z)  CRITICALITY=$OPTARG;;
  esac
done

CRITICALITY=${CRITICALITY:-critical}

if lspci | grep RAID | grep -i 3ware >> /dev/null; then
    sudo /etc/sensu/plugins/check_3ware_raid.py -b /usr/sbin/tw-cli -z $CRITICALITY
elif lspci | grep RAID | grep -i "MegaRAID" >> /dev/null; then
    if [[ -e /etc/sensu/plugins/check-storcli.pl && -e /usr/sbin/storcli64 ]];then
      sudo /etc/sensu/plugins/check-storcli.pl -p /usr/sbin/storcli64 -z $CRITICALITY
    else
      sudo /etc/sensu/plugins/check_megaraid_sas.pl -b /usr/sbin/megacli -o 63 -z $CRITICALITY
    fi
fi;
