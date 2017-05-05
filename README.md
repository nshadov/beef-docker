# Beef Dockerfile

## Description

Docker Image from this Dockerfile is built with care about security:

  * built on top of Ruby 2.2 with updated system level packages
  * built based on newest available Beef version from official GIT repo (http://github.com/beefproject/)
  * drops all unnecessary privileges
  * runs as non-root user inside container
  * runs on read-only filesystem, except essential files & directories
  * contains small helper for downloading configuration

## Downloading and running Docker container:

```
docker run -d --security-opt="no-new-privileges"  
              --cap-drop=all \
       	      --tmpfs=/home/beef-user/.aws/:uid=999 \
	          --tmpfs=/home/beef-user/extensions/admin_ui/media/:uid=999 \
	          -p 3000:3000 \
	          --name beef nshadov/beef
```

## Pulling configuration

Along with Dockerfile, to avoid using default passwords, a small script (```./get_config.sh```) is provided for pulling and updating your own configuration. It will be executed, every time container starts to avoid hardcoding your credentials into Docker Image stored in Image Repository.

It pulls config file from ```AWS S3``` specified with environment variable ```URI_CONFIG```. You can set it yourself or substitute this script by your own if you choose to use other delivery methods. If it fails last downloaded version will be used instead (or default ```beef:beef``` on the first run).

To pass environment variable to a container, run it with ```--env``` parameter:

```
docker run --env URI_CONFIG=s3://xxx/yyy ...
```

## Connect to service

To connect to service, navigate to: ```https://<container_ip>:3000/ui/panel``` (path could be changed in config file).
