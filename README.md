# Zuul CI

Testing Zuul CI with `podman kube play deployment.yaml`.

My motivation of this is that `podman-compose` in my thinking is more like an "temporary hack".
Not a long-term solution.
I believe that Kubernetes native manifest spec is far more superior and beneficial.
If done right, you could potentially run this very setup on a Minikube or full blown K8s cluster.
This would not be possible with `podman-compose` spec.

On top of that, I had never used Docker. :)

## SSH

My `~/.ssh/config` contains such config:

```bash
Host gerrit
  HostName gerrit
  Port 29418
  IdentityFile ~/.ssh/id_ed25519.pub
  User dzintars
```

This gives me ability to use particular SSH key when I am using `git clone` and `git review`.

I also change `.gitreview` file for `zuul-config` and `test1` repositories (after cloning)
from `host=localhost` to `host=gerrit`.

## /etc/hosts

I have added hostname `gerrit` for the `127.0.0.1` IP address.

## Podman Network

My podman network uses `netavark`:

```bash
podman info | grep network
>> networkBackend: netavark
```

Create separate `zuul` network:

```bash
podman network create zuul
```

By default that is `bridge` connection and can talk to the Host (not good for the security).
You can create `macvlan` (and `ipvlan`) connection, but I haven't tested it yet.

To remove the network use:

```bash
podman network rm zuul
```

## Usage

You can use `Containerfiles` to build the custom images "on the fly".
To "tie" those containerfiles into `deployment.yaml`, you need to place them into directories
which are named the same way as your image name in the deployment file. See my example of `node` and `logs`
images.

Then just run deployment with the `--build` flag. This will build those images before the deployment.

```bash
podman kube play --build --network zuul deployment.yaml
```

To run the deployment without building the custom `node` and `logs` images, just exclude the `--built` flag.
Basically, if you don't make changes to those images, you need to build them only once.

```bash
podman kube play --network zuul deployment.yaml
```

To remove the Zuul Pod use:

```bash
podman kube play --down deployment.yaml
```

This command will tear down all Zuul Pod containers but will not touch the volumes and network.

If you want to clean up all unused volumes, use this:

```bash
podman volume prune
```

I use it every time, I want to start setup from scratch.

To log into container use:

```bash
podman exec -it zuul-pod-node /bin/bash
```

Or if you want to obtain `root` privileges:

```bash
podman exec -u 0 -it zuul-pod-node /bin/bash
```

To see the list of all containers use:

```bash
podman ps -a
```

To see the logs of one particular container use:

```bash
podman logs zuul-pod-executor
```

To install latest development version of Podman (Fedora) use:

```bash
sudo dnf update --refresh --enablerepo=updates-testing podman
```
