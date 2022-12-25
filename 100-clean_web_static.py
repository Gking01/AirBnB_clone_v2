#!/usr/bin/python3
'''deletes out-of-date archives, using the function do_clean'''
import os
from datetime import datetime
from fabric.api import env, local, put, run, runs_once


env.hosts = ['34.198.248.145', '54.89.38.100']

def do_clean(number=0):
    # Delete all unnecessary archives in the versions folder
    local("ls -t versions | tail -n +%d | xargs rm" % (number+1))

    # Delete all unnecessary archives in the /data/web_static/releases folder of both web servers
    with cd("/data/web_static/releases"):
        run("ls -t | tail -n +%d | xargs rm -rf" % (number+1))
