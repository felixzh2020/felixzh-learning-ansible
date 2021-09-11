#!/usr/bin/python
import subprocess
import logging
import sys
import log
import os

logger=logging.getLogger("installSoft.py")
cur_path=os.path.dirname(os.path.abspath(__file__))

def execCmd(cmd, log=None, ret=None):
    res=subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, close_fds=True)
    if ret:
        for line in iter(res.stdout.readline, 'b'):
            return ret(line.rstrip("\n"))
    elif log:
        for line in iter(res.stdout.readline, 'b'):
            log(line.rstrip("\n"))
    res.communicate()
    res.stdout.close()
    return res.returncode

def installSoft(baseDir, soft):
    check_cmd='rpm -qa|grep ' + soft + '|head -1 | wc -l'
    res=execCmd(check_cmd, ret=lambda x: x)
    if res == '0':
       logger.info('begin install ' + soft)
       install_cmd='yum localinstall -y ' + baseDir + '/ansible/rpms/' + soft + '/*.rpm'
       execCmd(install_cmd)

    res1=execCmd(check_cmd, ret=lambda x: x)
    if res1=='1':
       logger.info(soft + ' install success !')
    else:
       logger.info(soft + ' install failed !')
       exit(1)

if __name__=="__main__":
    if len(sys.argv)!= 3:
        logger.error('params error !!')
        exit(-1)
    log.setup_logging(default_path= cur_path + "/logging.yaml")
    installSoft(sys.argv[1], sys.argv[2])

