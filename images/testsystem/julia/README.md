# Overview

Build Julia test image.

# Build

Use --PATCHLEVEL for patchlevel name.

Use --BETA=true to download BETA image.

Use --JUP_USER and --JUP_PASSWORD for basic auth user and password. 

Use --UBUNTU_VERSION=20.04 for base image version.

``` sh
# Local build
earthly +release --PATCHLEVEL=<patchlevel> --JUP_USER="user" --JUP_PASSWORD="password"

# To download from BETA use
earthly +release --PATCHLEVEL=<patchlevel> --BETA=true --JUP_USER="user" --JUP_PASSWORD="password"

# Build and push
earthly --push +release --UBUNTU_VERSION=22.04 --PATCHLEVEL=<patchlevel> --JUP_USER="user" --JUP_PASSWORD="password"

```

*Note*: Beta maybe unstable.
