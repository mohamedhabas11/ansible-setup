#!/bin/bash

BASE_IMAGES_DIR=/srv/libvirt/pool/base
BASE_TEMPLATE="${BASE_IMAGES_DIR}/k8s-base-template.qcow2"
HOSTS=$(host -al move.systems | grep '\.kube-office\.move\.systems' | grep -v '\-san\.' | awk '{print $1}' | sed -e 's/\.move\.systems\.$//')

if [ ! -d ${BASE_IMAGES_DIR} ] ; then
	mkdir ${BASE_IMAGES_DIR}
fi
