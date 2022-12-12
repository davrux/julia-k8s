# Overview

Build Julia Release images.

# Build

Use --PATCHLEVEL for patchlevel name.

Use --BASICAUTH for HTTP basic auth to download server. When not set, SSH is
used.

``` sh
# Local build
earthly +release --PATCHLEVEL=latest --BASICAUTH="user:password"

earthly +release --PATCHLEVEL=feature3 --BASICAUTH="user:password"
    
# Build and push
earthly --push +release --PATCHLEVEL=latest --BASICAUTH="user:password"

earthly --push +release --PATCHLEVEL=feature3 --BASICAUTH="user:password"
```

*Note*: latest maybe unstable.

