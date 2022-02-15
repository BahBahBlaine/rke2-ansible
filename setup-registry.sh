#!/usr/bin/env bash

set -e
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# cd to the same dir this script is in for relative paths to work properly
cd $SCRIPT_DIR


# change this to the ip address for the node or dns name for a multi-node setup
address=localhost:5000

# can also use podman or similar instead
docker run -d -p 5000:5000 --name registry registry:2 || /bin/true

registry_images=(
    registry1.dso.mil/ironbank/rancher-federal/rke2/klipper-helm:v0.6.1-build20210616
    registry1.dso.mil/ironbank/rancher-federal/rke2/calico:v3.13.3-build20210223
    registry1.dso.mil/ironbank/rancher-federal/rke2/coredns:v1.6.9-build20210223
    registry1.dso.mil/ironbank/rancher-federal/rke2/flannel:v0.13.0-rancher1-build20210223
    registry1.dso.mil/ironbank/rancher-federal/rke2/k8s-metrics-server:v0.3.6-build20210223
    registry1.dso.mil/ironbank/rancher-federal/rke2/etcd:v3.4.13-k3s1-build20210223
    registry1.dso.mil/ironbank/rancher-federal/rke2/hardened-kubernetes:v1.21.3-rke2r1-build20210721
    registry1.dso.mil/ironbank/rancher-federal/rke2/pause:3.5
    registry1.dso.mil/ironbank/rancher-federal/rke2/rke2-runtime:v1.21.3-rke2r1
    docker.io/rancher/rke2-cloud-provider:v0.0.1-build20210629
    docker.io/rancher/klipper-helm:v0.6.1-build20210616
)

for image in ${registry_images[@]}  ; do
    docker pull $image
    address_image_name=$(echo $image | cut -d '/' -f 2-)
    docker tag $image ${address}/${address_image_name}
    docker push ${address}/${address_image_name}
done


tarball_images=(

)

for image in ${tarball_images[@]} ; do
    docker pull $image
    tarball_name=$(echo ${image} | sed 's/\//-/g' | sed 's/\:/-/g').tar
    docker save -o tarball_install/${tarball_name}
done
