#!/usr/bin/python3
'''
fabric script to distribute an archive to web servers
'''

from fabric.api import env, put, run, task

env.hosts = ['34.198.248.145', '54.89.38.100']

@task
def do_deploy(archive_path):
    # Check if the file at the specified path exists
    if not run("test -f {}".format(archive_path)).succeeded:
        return False

    # Upload the archive to the /tmp/ directory on the web server
    put(archive_path, "/tmp/")

    # Get the filename of the archive without the extension
    filename = archive_path.split("/")[-1].split(".")[0]

    # Create the destination folder for the uncompressed archive on the web server
    run("mkdir -p /data/web_static/releases/{}".format(filename))

    # Uncompress the archive to the destination folder
    run("tar -xzf /tmp/{} -C /data/web_static/releases/{}".format(archive_path.split("/")[-1], filename))

    # Delete the archive from the web server
    run("rm /tmp/{}".format(archive_path.split("/")[-1]))

    # Delete the symbolic link /data/web_static/current from the web server
    run("rm -rf /data/web_static/current")

    # Create a new symbolic link /data/web_static/current on the web server, linked to the new version of the code
    run("ln -s /data
