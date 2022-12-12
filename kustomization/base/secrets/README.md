# Generate sealed secret:

First generate a normal secret by enabling secret generator in
kustomize.yaml:

``` yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: julia
resources:
  #- sealed-rclone-secret.yaml

configurations:
  - configuration/sealed-secret-config.yaml 

generatorOptions:
  annotations:
    sealedsecrets.bitnami.com/managed: "true"
    sealedsecrets.bitnami.com/namespace-wide: "true"

secretGenerator:
  - name: rclone-secret
    type: Opaque
    env: rclone.env
```


rclone.env

```sh
RCLONE_CONFIG_JULIA_ACCESS_KEY_ID=<AWS ACCESS KEY ID>
RCLONE_CONFIG_JULIA_SECRET_ACCESS_KEY=<AWS SECRET ACCESS KEY>
```

Now run to generate normal k8s secret:

    kubectl kustomize . > rclone-secret.yaml

Remove hash suffix from "name" on generated secret in rclone-secret.yaml. Now
change back kustomization.yaml:

``` yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
#namespace: julia
resources:
  - sealed-rclone-secret.yaml

configurations:
  - configuration/sealed-secret-config.yaml 

generatorOptions:
  annotations:
    sealedsecrets.bitnami.com/managed: "true"
    sealedsecrets.bitnami.com/namespace-wide: "true"

secretGenerator:
  - name: rclone-secret
    type: Opaque
    #env: rclone.env
```

We generate an empty secret and let sealed secrets manage it. Finally
generate sealed secret:

``` sh
./seal.sh
```
