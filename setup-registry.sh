#!/usr/bin/env bash

# change this to the ip address for the node or dns name for a multi-node setup
address=localhost:5000

# can also use podman or similar instead
docker run -d -p 5000:5000 --name registry registry:2

ironbank_images=(
    klipper-helm:v0.6.1-build20210616
    calico:v3.13.3-build20210223
    coredns:v1.6.9-build20210223
    flannel:v0.13.0-rancher1-build20210223
    k8s-metrics-server:v0.3.6-build20210223
)

for image in ${ironbank_images[@]}  ; do
    docker pull registry1.dso.mil/ironbank/rancher-federal/rke2/$image
    docker tag registry1.dso.mil/ironbank/rancher-federal/rke2/$image ${address}/ironbank/rancher-federal/rke2/$image
    docker push ${address}/ironbank/rancher-federal/rke2/$image
done

non_ironbank_images=(
    rancher/rke2-cloud-provider:v0.0.1-build20210629
)

for image in ${non_ironbank_images[@]} ; do
    docker pull $image
    docker tag $image ${address}/$image
    docker push ${address}/$image
done
