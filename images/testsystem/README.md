# Julia Development Test System

Build and push Julia. See julia/README.md for details.

``` sh
# No push
earthly +julia --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>

earthly --push +julia --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>
```


Build and push all

``` sh
# No push
earthly +all --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>

# Push
earthly --push +all --PATCHLEVEL=<patchlevel> --JUP_USER=<user> --JUP_PASSWORD=<pw>
```

Images generated (example output):

``` sh
docker image ls
REPOSITORY                                           TAG        IMAGE ID       CREATED          SIZE
docker.allgeier-it.de:5000/julia36-ubuntu2004-test   feature3   4590cf608061   22 minutes ago   2.7GB
docker.allgeier-it.de:5000/julia36-postfix-dovecot   latest     b66b338dc024   24 minutes ago   210MB
docker.allgeier-it.de:5000/mongo                     latest     31291f65ee9a   24 minutes ago   700MB
```
