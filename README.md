# k8s
CBSD module to deploy kubernetes cluster

This module requires the kubernetes cloud image, please fetch via:

`cbsd fetch_iso name=cloud-kubernetes-25 dstdir=default cloud=1 conv2zvol=1`

To install:

```sh
cbsd module mode=install k8s
echo 'k8s.d' >> ~cbsd/etc/modules.conf
cbsd initenv
```

Quick start:

  `cbsd k8s mode=init`

  Refer to the [documentation page](https://www.bsdstore.ru/en/12.x/wf_k8s_ssi.html).


# Play with k8s

`kubectl run my-shell --rm -i --tty --image ubuntu -- bash`

When the pod is running: 
`kubectl attach my-shell -c my-shell -i -t`
