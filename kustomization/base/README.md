# Julia Kustomization

# Overview

A Julia system runs as a StatefulSet with a container for each needed service. A julia pod exposes the following ports:

- 22 SSH
- 25 MailOffice interface
- 26 Gateway Interface
- 443 Webinterface

All variable data, like postfix queues and julia queues are saved to
/opt/julia/var. The folders /opt/julia/etc and /opt/julia/jup are symlinks to
/opt/julia/var/etc and /opt/julia/var/jup.

# InitContainer

When a Julia pod is starting, an InitContainer is started first. This
InitContainer starts the script

``` sh
/app/boostrap.sh
```

First the script links the julia/etc and julia/jup directories, when not already
done. Second the script 

``` sh
load-cfg-update.sh
```

is called to load an archive via rclone and save it to

``` sh
/opt/julia/var/cfg-update.tar.gz
```

The archives filename to load is determined by the content of the file

``` sh
/config/config-version
```

The content should be some sort of timestamp like

``` sh
cat /config/config-version
1670495932-08122022
```

The file loaded by rclone is then

``` sh
1670495932-08122022.tar.gz
```

The configuration is loaded using rclone to /opt/julia//var/cfg-update.tar.gz.
Then

``` sh
/app/cfg-update.sh 
```

extract it. This script will simply extract the file
/opt/julia/var/cfg-update.tar.gz. After extraction it's deleted. When the file
does not exist, the extraction is skipped.

The file /config/config-version is used in a ConfigMap on k8s. So whenever the
content changes the julia pod will be restarted and the InitContainers bootstrap
process will update the Julia StatefulSet to the latest configuration. See the
config folder for kustomization and rclone.conf.

The files config/config.cfg and rclone.conf configure the rclone access.

``` sh
cat config/config.cfg

USE_RCLONE="true"
RCLONE_CLOUD_STORE="julia:allgeieritjuliatest"
ADDITIONAL_RCLONE_OPTIONS="--auto-confirm"
```

``` ini
[julia]
type = s3
provider = AWS
env_auth = true
#access_key_id =
#secret_access_key =
region = eu-central-1
location_constraint = EU
acl = private
```

One can use environment variables for access to AWS S3:

``` sh
RCLONE_CONFIG_JULIA_ACCESS_KEY_ID=<AWS ACCESS KEY>
RCLONE_CONFIG_JULIA_SECRET_ACCESS_KEY=<AWS SECRET KEY>
```

## Disable automatic updates via rclone

To skip automatic configuration loading, do not add the files

``` sh
/app/config-version
/app/config.cfg 
```

to the Julia pod.
