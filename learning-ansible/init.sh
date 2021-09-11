#!/bin/bash

BASE_DIR=$(cd `dirname $0`;pwd)

##################自定义ansible.cfg###############################
sed -i "s/^inventory=.*/inventory=${BASE_DIR////\/}\/conf\/hosts/g" $BASE_DIR/conf/ansible.cfg
sed -i "s/^#host_key_checking.*/host_key_checking=False/g" $BASE_DIR/conf/ansible.cfg
sed -i "s/^#gathering.*/gathering=smart/g" $BASE_DIR/conf/ansible.cfg
sed -i "s/^#log_path.*/log_path=${BASE_DIR////\/}\/ansible.log/g" $BASE_DIR/conf/ansible.cfg

##################自定义环境变量ANSIBLE_CONFIG####################
echo "export ANSIBLE_CONFIG=${BASE_DIR}/conf/ansible.cfg"  > ${BASE_DIR}/ansible_config_env
chmod +x ${BASE_DIR}/ansible_config_env

