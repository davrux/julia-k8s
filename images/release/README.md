# Overview

Build Julia Release images.

# Build

Use --PATCHLEVEL for patchlevel name.

Use --BETA=true to download BETA image.

Use --JUP_USER and --JUP_PASSWORD for basic auth user and password. 

``` sh
# No push
earthly +release --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>

# Push
earthly --push +release --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>
```

*Note*: Beta maybe unstable.

