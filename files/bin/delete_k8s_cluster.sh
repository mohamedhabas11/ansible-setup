#!/bin/bash

HOSTS=$(host -al move.systems | grep '\.kube-office\.move\.systems' | grep -v '\-san\.' | awk '{print $1}' | sed -e 's/\.move\.systems\.$//')

for HOST in ${HOSTS} ; do

    virsh destroy ${HOST}

done


for HOST in ${HOSTS} ; do

    virsh undefine --domain ${HOST} --remove-all-storage

done

