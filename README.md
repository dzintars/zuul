# Zuul CI

Testing Zuul CI with Podman kube play deployment.

## SSH

## /etc/hosts

## Podman Network

```bash
podman network create zuul
```

By default that is `bridge` network and can talk to Host (not good for the security).

## Usage

You can use `Containerfiles` to build the custom images "on the fly".

```bash
podman kube play --build --network zuul deployment.yaml
```

To run the deployment without building the images, just exclude the `--built` flag:

```bash
podman kube play --network zuul deployment.yaml
```

To remove the Pod use:

```bash
podman kube play --down deployment.yaml
```

This command will not touch the volumes.

If you want to clean up all unused volumes, use this:

```bash
podman volume prune
```

To log into container use:

```bash
podman exec -it zuul-pod-node /bin/bash
```

Or if you want to obtain `root` privilege:

```bash
podman exec -u 0 -it zuul-pod-node /bin/bash
```

To install latest development version of Podman (Fedora) use:

```bash
sudo dnf update --refresh --enablerepo=updates-testing podman
```
